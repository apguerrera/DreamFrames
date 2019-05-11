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
// Maintain a list of operators that are permissioned to execute certain
// functions
// ----------------------------------------------------------------------------
contract Operated is Owned {
    mapping(address => bool) public operators;

    event OperatorAdded(address _operator);
    event OperatorRemoved(address _operator);

    modifier onlyOperator() {
        require(operators[msg.sender] || owner == msg.sender);
        _;
    }

    function initOperated(address _owner) internal {
        initOwned(_owner);
    }
    function addOperator(address _operator) public onlyOwner {
        require(!operators[_operator]);
        operators[_operator] = true;
        emit OperatorAdded(_operator);
    }
    function removeOperator(address _operator) public onlyOwner {
        require(operators[_operator]);
        delete operators[_operator];
        emit OperatorRemoved(_operator);
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

contract DreamFramesRoyaltyCrowdsale is Operated {

    using SafeMath for uint256;

    uint256 public contributedEth;
    DreamFramesCSInterface public crowdsaleContract;
    address payable public wallet;
    mapping(address => uint256) public royaltyEthAmount;
    uint256 public royaltiesSold;
    uint256 public maxRoyaltyFrames;
    event Purchased(address indexed addr, uint256 frames, uint256 ethToTransfer, uint256 royaltiesSold, uint256 contributedEth);
    event SetFrameCrowdsale(address oldCrowdsaleContract, address newCrowdsaleContract);
    event WalletUpdated(address indexed oldWallet, address indexed newWallet);
    event MaxRoyaltyFramesUpdated(uint256 oldMaxRoyaltyFrames,  uint256 newMaxRoyaltyFrames);

    constructor(address payable _wallet, address _crowdsaleContract, uint256 _maxRoyaltyFrames) public {
      require(_wallet != address(0));
      require(_crowdsaleContract != address(0));
      wallet = _wallet;
      maxRoyaltyFrames = _maxRoyaltyFrames;
      crowdsaleContract = DreamFramesCSInterface(_crowdsaleContract);
      initOperated(msg.sender);
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
    function setMaxRoyaltyFrames(uint256 _maxRoyaltyFrames) public onlyOwner {
      require(_maxRoyaltyFrames >= royaltiesSold);
      emit MaxRoyaltyFramesUpdated(maxRoyaltyFrames, _maxRoyaltyFrames);
      maxRoyaltyFrames = _maxRoyaltyFrames;
    }

    // Call functions
    function framesRemaining() public view returns (uint256) {
      return maxRoyaltyFrames.sub(royaltiesSold);
    }
    function pctSold() public view returns (uint256) {
      return royaltiesSold.mul(100).div(maxRoyaltyFrames);
    }
    function pctRemaining() public view returns (uint256) {
      return maxRoyaltyFrames.sub(royaltiesSold).mul(100).div(maxRoyaltyFrames);
    }
    function calculateRoyaltyFrames(uint256 ethAmount) public view returns (uint256 frames, uint256 ethToTransfer) {
        // Number of frames available to purchase
        (frames, ethToTransfer) = crowdsaleContract.calculateFrames(ethAmount);

        // Add maxFrames for investor restrictions
        uint256 _frameEth;
        bool _live;
        (_frameEth, _live) = crowdsaleContract.frameEth();
        require(_live);
        if (royaltiesSold.add(frames) >= maxRoyaltyFrames) {
            frames = maxRoyaltyFrames.sub(royaltiesSold);
        }
        ethToTransfer = frames.mul(_frameEth);

    }

    // Deposit function
    function () external payable {
        require(now >= startDate && now <= endDate);
        // Get number of frames, will revert if sold out
        uint256 ethToTransfer;
        uint256 frames;
        (frames, ethToTransfer) = calculateRoyaltyFrames( msg.value);

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

    function offlineRoyaltyPurchase(address tokenOwner, uint256 frames) external onlyOperator {
          require(frames > 0);
          require(royaltiesSold.add(frames) <= maxRoyaltyFrames);
          (uint256 _frameEth, bool _live) = crowdsaleContract.frameEth();
          require(_live);

          // Update crowdsale contract state
          uint256 ethToTransfer = frames.mul(_frameEth);
          royaltiesSold = royaltiesSold.add(frames);
          contributedEth = contributedEth.add(ethToTransfer);
          royaltyEthAmount[tokenOwner] = royaltyEthAmount[tokenOwner].add(ethToTransfer);

          // Claim royalty frames
          crowdsaleContract.claimRoyaltyFrames(tokenOwner,frames, ethToTransfer);
          emit Purchased(tokenOwner, frames, 0, royaltiesSold, contributedEth);
      }



}
