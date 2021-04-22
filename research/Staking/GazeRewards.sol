pragma solidity ^0.6.12;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./Utils/GazeAccessControls.sol";
import "../interfaces/IUniswapV2Pair.sol";
import "../interfaces/IERC20.sol";
import "./Uniswap/UniswapV2Library.sol";

interface IGazeStaking{
    function stakedEthTotal() external view returns (uint256);
    function lpToken() external view returns (address);
    function WETH() external view returns (address);
}
interface Rewards is IERC20 {
    function mint(address tokenOwner, uint tokens) external returns (bool);
}

contract GazeRewards {
    using SafeMath for uint256;

    /* ========== Variables ========== */

    Rewards public rewardsToken;
    /// @notice Contract GazeAccessControls.
    GazeAccessControls public accessControls;
    IGazeStaking public lpStaking;
    address public vault;

    uint256 constant POINT_MULTIPLIER = 10e18;
    uint256 constant PERIOD_LENGTH = 14;
    uint256 constant SECONDS_PER_DAY = 24 * 60 * 60;
    uint256 constant SECONDS_PER_PERIOD = PERIOD_LENGTH * SECONDS_PER_DAY;
    
    // weekNumber => rewards
    mapping (uint256 => uint256) public weeklyRewardsPerSecond;

    uint256 public startTime;
    uint256 public lastRewardTime;

    uint256 public lpRewardsPaid;

    /* ========== Structs ========== */

    struct Weights {
        uint256 lpWeightPoints;
    }

    /// @notice mapping of a staker to its current properties
    mapping (uint256 => Weights) public weeklyWeightPoints;

    /* ========== Events ========== */

    event RewardAdded(address indexed addr, uint256 reward);
    event RewardDistributed(address indexed addr, uint256 reward);
    event Recovered(address indexed token, uint256 amount);

    
    /* ========== Admin Functions ========== */
    constructor(
        address _rewardsToken,
        address _accessControls,
        address _lpStaking,
        uint256 _startTime,
        uint256 _lastRewardTime,
        uint256 _lpRewardsPaid
    )
        public
    {
        rewardsToken = Rewards(_rewardsToken);
        accessControls = GazeAccessControls(_accessControls);
        lpStaking = IGazeStaking(_lpStaking);
        startTime = _startTime;
        lastRewardTime = _lastRewardTime;
        lpRewardsPaid = _lpRewardsPaid;        
    }

    /// @dev Setter functions for contract config
    function setStartTime(
        uint256 _startTime,
        uint256 _lastRewardTime
    )
        external
    {
        require(
            accessControls.hasAdminRole(msg.sender),
            "GazeRewards.setStartTime: Sender must be admin"
        );
        startTime = _startTime;
        lastRewardTime = _lastRewardTime;
    }

    /// @dev Setter functions for contract config
    function setInitialPoints(
        uint256 week,
        uint256 mW

    )
        external
    {
        require(
            accessControls.hasAdminRole(msg.sender),
            "GazeRewards.setInitialPoints: Sender must be admin"
        );
        Weights storage weights = weeklyWeightPoints[week];
        weights.lpWeightPoints = mW;

    }

    function setLPStaking(
        address _addr
    )
        external
    {
        require(
            accessControls.hasAdminRole(msg.sender),
            "GazeRewards.setLPStaking: Sender must be admin"
        );
        lpStaking = IGazeStaking(_addr);
    } 

    function setVault(
        address _addr
    )
        external
    {
        require(
            accessControls.hasAdminRole(msg.sender),
            "GazeRewards.setVault: Sender must be admin"
        );
        vault = _addr;
    } 

    /// @notice Set rewards distributed each week
    /// @dev this number is the total rewards that week with 18 decimals
    function setRewards(
        uint256[] memory rewardWeeks,
        uint256[] memory amounts
    )
        external
    {
        require(
            accessControls.hasAdminRole(msg.sender),
            "GazeRewards.setRewards: Sender must be admin"
        );
        uint256 numRewards = rewardWeeks.length;
        for (uint256 i = 0; i < numRewards; i++) {
            uint256 week = rewardWeeks[i];
            uint256 amount = amounts[i].mul(POINT_MULTIPLIER)
                                       .div(SECONDS_PER_PERIOD)
                                       .div(POINT_MULTIPLIER);
            weeklyRewardsPerSecond[week] = amount;
        }
    }


    // From BokkyPooBah's DateTime Library v1.01
    // https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
    function diffDays(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _days) {
        require(fromTimestamp <= toTimestamp);
        _days = (toTimestamp - fromTimestamp) / SECONDS_PER_DAY;
    }


    /* ========== Mutative Functions ========== */

    /// @notice Calculate the current normalised weightings and update rewards
    /// @dev 
    function updateRewards() 
        external
        returns(bool)
    {
        if (block.timestamp <= lastRewardTime) {
            return false;
        }

        uint256 m_net = lpStaking.stakedEthTotal();

        /// @dev check that the staking pools have contributions, and rewards have started
        if (m_net == 0 || block.timestamp <= startTime) {
            lastRewardTime = block.timestamp;
            return false;
        }

        _updateLPRewards();

        /// @dev update accumulated reward
        lastRewardTime = block.timestamp;
        return true;
    }


    /* ========== View Functions ========== */

    /// @notice Gets the total rewards outstanding from last reward time
    function totalRewards() external view returns (uint256) {
        uint256 lRewards = LPRewards(lastRewardTime, block.timestamp);
        return lRewards;     
    }


    /// @notice Gets the total contributions from the staked contracts
    function getTotalContributions()
        external
        view
        returns(uint256)
    {
        return lpStaking.stakedEthTotal();
    }

    /// @dev Getter functions for Rewards contract
    function getCurrentRewardWeek()
        external 
        view 
        returns(uint256)
    {
        return diffDays(startTime, block.timestamp) / PERIOD_LENGTH;
    }

    function totalRewardsPaid()
        external
        view
        returns(uint256)
    {
        return lpRewardsPaid;
    } 

  

    /// @notice Return LP rewards over the given _from to _to timestamp.
    /// @dev A fraction of the start, multiples of the middle weeks, fraction of the end
    function LPRewards(uint256 _from, uint256 _to) public view returns (uint256 rewards) {
        if (_to <= startTime) {
            return 0;
        }
        if (_from < startTime) {
            _from = startTime;
        }
        uint256 fromWeek = diffDays(startTime, _from) / PERIOD_LENGTH;                      
        uint256 toWeek = diffDays(startTime, _to) / PERIOD_LENGTH;                          

        if (fromWeek == toWeek) {
            return _rewardsFromPoints(weeklyRewardsPerSecond[fromWeek], _to.sub(_from));
        }

        /// @dev First count remainer of first week 
        uint256 initialRemander = startTime.add((fromWeek+1).mul(SECONDS_PER_PERIOD)).sub(_from);
        rewards = _rewardsFromPoints(weeklyRewardsPerSecond[fromWeek], initialRemander);

        /// @dev add multiples of the week
        for (uint256 i = fromWeek+1; i < toWeek; i++) {
            rewards = rewards.add(_rewardsFromPoints(weeklyRewardsPerSecond[i],SECONDS_PER_PERIOD));
        }
        /// @dev Adds any remaining time in the most recent week till _to
        uint256 finalRemander = _to.sub(toWeek.mul(SECONDS_PER_PERIOD).add(startTime));
        rewards = rewards.add(_rewardsFromPoints(weeklyRewardsPerSecond[toWeek], finalRemander));

        return rewards;
    }


    /* ========== Internal Functions ========== */

    function _updateLPRewards() 
        internal
        returns(uint256 rewards)
    {
        rewards = LPRewards(lastRewardTime, block.timestamp);
        if ( rewards > 0 ) {
            lpRewardsPaid = lpRewardsPaid.add(rewards);
            require(rewardsToken.transferFrom(vault, address(lpStaking), rewards));
        }
    }

    function _rewardsFromPoints(
        uint256 rate,
        uint256 duration
    ) 
        internal
        pure
        returns(uint256)
    {
        return rate.mul(duration);
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a >= b ? a : b;
    }



    /* ========== Recover ERC20 ========== */

    /// @notice allows for the recovery of incorrect ERC20 tokens sent to contract
    function recoverERC20(
        address tokenAddress,
        uint256 tokenAmount
    )
        external
    {
        // Cannot recover the staking token or the rewards token
        require(
            accessControls.hasAdminRole(msg.sender),
            "GazeRewards.recoverERC20: Sender must be admin"
        );
        require(
            tokenAddress != address(rewardsToken),
            "Cannot withdraw the rewards token"
        );
        IERC20(tokenAddress).transfer(msg.sender, tokenAmount);
        emit Recovered(tokenAddress, tokenAmount);
    }


    /* ========== Getters ========== */

    function getCurrentWeek()
        external
        view
        returns(uint256)
    {
        return diffDays(startTime, block.timestamp) / PERIOD_LENGTH;
    }

    function getCurrentLpWeightPoints()
        external
        view
        returns(uint256)
    {
        uint256 currentWeek = diffDays(startTime, block.timestamp) / PERIOD_LENGTH;
        return weeklyWeightPoints[currentWeek].lpWeightPoints;
    }

    function getLpStakedEthTotal()
        public
        view
        returns(uint256)
    {
        return lpStaking.stakedEthTotal();
    }

    function getLpDailyAPY()
        external
        view 
        returns (uint256) 
    {
        uint256 stakedEth = getLpStakedEthTotal();
        if ( stakedEth == 0 ) {
            return 0;
        }
        /// @dev hours per year x 100 = 876600
        uint256 rewards = LPRewards(block.timestamp - 3600, block.timestamp);
        uint256 multiplier = 876600;
        if (rewards == 0) {
            /// @dev days per year x 100 = 36525
            rewards = LPRewards(block.timestamp - 86400, block.timestamp);
            multiplier = 36525;
        }
        uint256 rewardsInEth = rewards.mul(getEthPerRewardPrice()).div(1e18);
        return rewardsInEth.mul(multiplier).mul(1e18).div(stakedEth);
    } 

    function getRewardPerEthPrice()
        public 
        view 
        returns (uint256)
    {
        (uint256 wethReserve, uint256 tokenReserve) = getPairReserves();
        return UniswapV2Library.quote(1e18, wethReserve, tokenReserve);
    }

    function getEthPerRewardPrice()
        public
        view
        returns (uint256)
    {
        (uint256 wethReserve, uint256 tokenReserve) = getPairReserves();
        return UniswapV2Library.quote(1e18, tokenReserve, wethReserve);
    }

    function getPairReserves() internal view returns (uint256 wethReserves, uint256 tokenReserves) {
        (address token0,) = UniswapV2Library.sortTokens(address(lpStaking.WETH()), address(rewardsToken));
        (uint256 reserve0, uint reserve1,) = IUniswapV2Pair(lpStaking.lpToken()).getReserves();
        (wethReserves, tokenReserves) = token0 == address(rewardsToken) ? (reserve1, reserve0) : (reserve0, reserve1);
    }

}