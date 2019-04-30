pragma solidity ^0.5.4;

// ----------------------------------------------------------------------------
// DreamFrames Crowdsale Contract - Purchase royalty tokens and frames with ETH
//
// Deployed to : {TBA}
//
// Enjoy.
//
// (c) BokkyPooBah / Bok Consulting Pty Ltd for GazeCoin 2018. The MIT Licence.
// (c) Adrian Guerrera / Deepyr Pty Ltd for Dreamframes 2019. The MIT Licence.
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;
    bool private initialised;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function initOwned(address _owner) internal {
        require(!initialised);
        owner = _owner;
        initialised = true;
    }
    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
    function transferOwnershipImmediately(address _newOwner) public onlyOwner {
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}

// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
        require(b > 0);
        c = a / b;
    }
    function max(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a >= b ? a : b;
    }
    function min(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a <= b ? a : b;
    }
}


// ----------------------------------------------------------------------------
// DreamFramesToken Contract
// ----------------------------------------------------------------------------
contract DreamFramesCSInterface {
    function claimRoyaltyFrames(address tokenOwner, uint256 frames, uint256 ethToTransfer) external;
    function frameEth() external view returns (uint _rate, bool _live);
    function calculateFrames(uint256 ethAmount) external view returns (uint256 frames, uint256 ethToTransfer);
}

contract DreamFramesRoyaltyCrowdsale is Owned {

    using SafeMath for uint256;

    uint256 public contributedEth;
    DreamFramesCSInterface public crowdsaleContract;
    address payable public wallet;
    mapping(address => uint256) public royaltyEthAmount;
    uint256 public royaltiesSold;

    event Purchased(address indexed addr, uint256 frames, uint256 ethToTransfer, uint256 royaltiesSold, uint256 contributedEth);
    event SetFrameCrowdsale(address oldCrowdsaleContract, address newCrowdsaleContract);
    event WalletUpdated(address indexed oldWallet, address indexed newWallet);

    constructor(address payable _wallet, address _crowdsaleContract) public {
      require(_wallet != address(0));
      require(_crowdsaleContract != address(0));
      wallet = _wallet;
      crowdsaleContract = DreamFramesCSInterface(_crowdsaleContract);
      initOwned(msg.sender);
    }

    // Setter functions
    function setFrameCrowdsaleContract(address _crowdsaleContract) public onlyOwner {
      require(_crowdsaleContract != address(0));
       emit SetFrameCrowdsale(address(crowdsaleContract), _crowdsaleContract);
       crowdsaleContract = DreamFramesCSInterface(_crowdsaleContract);
    }
    function setWallet(address payable _wallet) public onlyOwner {
        require(_wallet != address(0));
        emit WalletUpdated(wallet, _wallet);
        wallet = _wallet;
    }

    function () external payable {
        // require(now >= startDate && now <= endDate);
        // Get number of frames, will revert if sold out
        uint256 ethToTransfer;
        uint256 frames;
        (frames, ethToTransfer) = crowdsaleContract.calculateFrames( msg.value);

        // Update crowdsale contract state
        royaltiesSold = royaltiesSold.add(frames);
        contributedEth = contributedEth.add(ethToTransfer);
        royaltyEthAmount[msg.sender] = royaltyEthAmount[msg.sender].add(ethToTransfer);

        // Accept Payments
        uint256 ethToRefund = msg.value.sub(ethToTransfer);
        if (ethToTransfer > 0) {
            wallet.transfer(ethToTransfer);
        }
        if (ethToRefund > 0) {
            msg.sender.transfer(ethToRefund);
        }
        // Issue royalty tokens
        crowdsaleContract.claimRoyaltyFrames(msg.sender, frames, ethToTransfer);
        emit Purchased(msg.sender, frames, ethToTransfer, royaltiesSold, contributedEth);
    }

    /*
    //  AG: To Remove
    function withdrawFunds() public onlyOwner {
        // AG: Crowdsale over
        msg.sender.transfer(address(this).balance);
    }
    */
}
