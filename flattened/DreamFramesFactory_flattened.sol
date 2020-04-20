pragma solidity ^0.5.4;



// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address payable public owner;
    address public newOwner;
    bool private initialised;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function initOwned(address  _owner) internal {
        require(!initialised);
        owner = address(uint160(_owner));
        initialised = true;
    }
    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership()  public  {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = address(uint160(newOwner));
        newOwner = address(0);
    }
    function transferOwnershipImmediately(address _newOwner) public onlyOwner {
        emit OwnershipTransferred(owner, _newOwner);
        owner = address(uint160(_newOwner));
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
// DreamFrames Crowdsale Contract - Purchase FrameRush Tokens with ETH
//
// Deployed to : {TBA}
//
// Enjoy.
//
// (c) BokkyPooBah / Bok Consulting Pty Ltd for GazeCoin 2018. The MIT Licence.
// (c) Adrian Guerrera / Deepyr Pty Ltd for Dreamframes 2019. The MIT Licence.
// ----------------------------------------------------------------------------


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
    function mod(uint256 a, uint256 b) internal pure returns (uint256 c) {
        require(b != 0);
        c =  a % b;
    }
}

// ----------------------------------------------------------------------------
// BokkyPooBah's Token Teleportation Service Interface v1.20
//
// https://github.com/bokkypoobah/BokkyPooBahsTokenTeleportationServiceSmartContract
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

  function totalSupply() public view returns (uint);
  function balanceOf(address tokenOwner) public view returns (uint balance);
  function allowance(address tokenOwner, address spender) public view returns (uint remaining);
  function transfer(address to, uint tokens) public returns (bool success);
  function approve(address spender, uint tokens) public returns (bool success);
  function transferFrom(address from, address to, uint tokens) public returns (bool success);
}

// ----------------------------------------------------------------------------
// Contracts that can have tokens approved, and then a function executed
// ----------------------------------------------------------------------------
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}


// ----------------------------------------------------------------------------
// BokkyPooBah's Token Teleportation Service Interface v1.10
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------
contract BTTSTokenInterface is ERC20Interface {
  uint public constant bttsVersion = 120;

     bytes public constant signingPrefix = "\x19Ethereum Signed Message:\n32";
     bytes4 public constant signedTransferSig = "\x75\x32\xea\xac";
     bytes4 public constant signedApproveSig = "\xe9\xaf\xa7\xa1";
     bytes4 public constant signedTransferFromSig = "\x34\x4b\xcc\x7d";
     bytes4 public constant signedApproveAndCallSig = "\xf1\x6f\x9b\x53";

     event OwnershipTransferred(address indexed from, address indexed to);
     event MinterUpdated(address from, address to);
     event Mint(address indexed tokenOwner, uint tokens, bool lockAccount);
     event MintingDisabled();
     event TransfersEnabled();
     event AccountUnlocked(address indexed tokenOwner);

     function symbol() public view returns (string memory);
     function name() public view returns (string memory);
     function decimals() public view returns (uint8);

     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success);

     // ------------------------------------------------------------------------
     // signed{X} functions
     // ------------------------------------------------------------------------
     function signedTransferHash(address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
     function signedTransferCheck(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public view returns (CheckResult result);
     function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success);

     function signedApproveHash(address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
     function signedApproveCheck(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public view returns (CheckResult result);
     function signedApprove(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success);

     function signedTransferFromHash(address spender, address from, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
     function signedTransferFromCheck(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public view returns (CheckResult result);
     function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success);

     function signedApproveAndCallHash(address tokenOwner, address spender, uint tokens, bytes memory _data, uint fee, uint nonce) public view returns (bytes32 hash);
     function signedApproveAndCallCheck(address tokenOwner, address spender, uint tokens, bytes memory _data, uint fee, uint nonce, bytes memory sig, address feeAccount) public view returns (CheckResult result);
     function signedApproveAndCall(address tokenOwner, address spender, uint tokens, bytes memory _data, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success);

     function mint(address tokenOwner, uint tokens, bool lockAccount) public returns (bool success);
     function unlockAccount(address tokenOwner) public;
     function disableMinting() public;
     function enableTransfers() public;
     function mintable() public view returns (bool success);

     function setMinter(address minter) public;

     // ------------------------------------------------------------------------
     // signed{X}Check return status
     // ------------------------------------------------------------------------
     enum CheckResult {
         Success,                           // 0 Success
         NotTransferable,                   // 1 Tokens not transferable yet
         AccountLocked,                     // 2 Account locked
         SignerMismatch,                    // 3 Mismatch in signing account
         InvalidNonce,                      // 4 Invalid nonce
         InsufficientApprovedTokens,        // 5 Insufficient approved tokens
         InsufficientApprovedTokensForFees, // 6 Insufficient approved tokens for fees
         InsufficientTokens,                // 7 Insufficient tokens
         InsufficientTokensForFees,         // 8 Insufficient tokens for fees
         OverflowError                      // 9 Overflow error
     }
}

// ----------------------------------------------------------------------------
// PriceFeed Interface - _live is true if the rate is valid, false if invalid
// ----------------------------------------------------------------------------
contract PriceFeedInterface {
    function getRate() public view returns (uint _rate, bool _live);
}

// ----------------------------------------------------------------------------
// Bonus List interface
// ----------------------------------------------------------------------------
contract WhiteListInterface {
    function isInWhiteList(address account) public view returns (bool);
}

// ----------------------------------------------------------------------------
// DreamFramesToken Contract
// ----------------------------------------------------------------------------
contract DreamFramesCrowdsale is Operated {
  using SafeMath for uint256;

  uint256 private constant TENPOW18 = 10 ** 18;

  BTTSTokenInterface public frameRushToken;
  BTTSTokenInterface public royaltyToken;
  WhiteListInterface public whiteList;
  PriceFeedInterface public ethUsdPriceFeed;

  address payable public wallet;
  address public royaltyCrowdsaleAddress;
  uint256 public startDate;
  uint256 public endDate;
  uint256 public minFrames;

  uint256 public maxFrames;
  uint256 public producerFrames;

  uint256 public frameUsd;

  uint256 public framesSold;
  bool public finalised;
  uint256 public bonusOffList;
  uint256 public contributedEth;
  uint256 public softCapUsd;
  uint256 public hardCapUsd;
  uint256 public lockedAccountThresholdUsd;
  mapping(address => uint256) public accountEthAmount;

  event WalletUpdated(address indexed oldWallet, address indexed newWallet);
  event StartDateUpdated(uint256 oldStartDate, uint256 newStartDate);
  event EndDateUpdated(uint256 oldEndDate, uint256 newEndDate);
  event MaxFramesUpdated(uint256 oldMaxFrames, uint256 newMaxFrames);
  event MinFramesUpdated(uint256 oldMinFrames, uint256 newMinFrames);

  event FrameUsdUpdated(uint256 oldFrameUsd, uint256 newFrameUsd);
  event BonusOffListUpdated(uint256 oldBonusOffList, uint256 newBonusOffList);
  event Purchased(address indexed addr, uint256 frames, uint256 ethToTransfer, uint256 framesSold, uint256 contributedEth);
  event RoyaltyCrowdsaleUpdated(address indexed oldRoyaltyCrowdsaleAddress, address indexed  newRoyaltyCrowdsaleAddres);

  constructor(address _frameRushToken, address _royaltyToken, address _ethUsdPriceFeed, address _whiteList ) public {
      require(_frameRushToken != address(0));
      require(_royaltyToken != address(0));
      require(_ethUsdPriceFeed != address(0) );
      require(_whiteList != address(0) );
      initOperated(msg.sender);
      frameRushToken = BTTSTokenInterface(_frameRushToken);
      royaltyToken = BTTSTokenInterface(_royaltyToken);
      ethUsdPriceFeed = PriceFeedInterface(_ethUsdPriceFeed);
      whiteList = WhiteListInterface(_whiteList);
  }

  function init(address payable _wallet, uint256 _startDate, uint256 _endDate, uint256 _minFrames, uint256 _maxFrames, uint256 _producerFrames, uint256 _frameUsd, uint256 _bonusOffList, uint256 _hardCapUsd, uint256 _softCapUsd) public {
      require(_wallet != address(0));
      require(_endDate > _startDate);
      // require(_startDate >= now);
      require(_maxFrames > 0 && _frameUsd > 0);
      require(_maxFrames > _minFrames);
      require(_maxFrames.mod(_minFrames) == 0);
      lockedAccountThresholdUsd = 10000;
      minFrames = _minFrames;
      hardCapUsd = _hardCapUsd;
      softCapUsd = _softCapUsd;
      frameUsd = _frameUsd;
      wallet = _wallet;
      startDate = _startDate;
      endDate = _endDate;
      maxFrames = _maxFrames;
      producerFrames = _producerFrames;
      bonusOffList = _bonusOffList;

      // require(hardCapUsd >= _maxFrames.mul(_frameUsd).div(TENPOW18));
      // require(softCapUsd <= _maxFrames.mul(frameUsdWithBonus()).div(TENPOW18) );


  }
  // Setter functions
  function setWallet(address payable _wallet) public onlyOwner {
      require(!finalised);
      require(_wallet != address(0));
      emit WalletUpdated(wallet, _wallet);
      wallet = _wallet;
  }
  function setRoyaltyCrowdsale(address _royaltyCrowdsaleAddres) public onlyOwner {
      require(!finalised);
      require(_royaltyCrowdsaleAddres != address(0));
      emit RoyaltyCrowdsaleUpdated(royaltyCrowdsaleAddress, _royaltyCrowdsaleAddres);
      royaltyCrowdsaleAddress = _royaltyCrowdsaleAddres;
  }
  function setStartDate(uint256 _startDate) public onlyOwner {
      require(!finalised);
      require(_startDate >= now);
      emit StartDateUpdated(startDate, _startDate);
      startDate = _startDate;
  }
  function setEndDate(uint256 _endDate) public onlyOwner {
      require(!finalised);
      require(_endDate > startDate);
      emit EndDateUpdated(endDate, _endDate);
      endDate = _endDate;
  }
  function setMaxFrames(uint256 _maxFrames) public onlyOwner {
      require(!finalised);
      require(_maxFrames >= framesSold);
      require(_maxFrames.mod(minFrames) == 0);
      emit MaxFramesUpdated(maxFrames, _maxFrames);
      maxFrames = _maxFrames;
  }
  function setMinFrames(uint256 _minFrames) public onlyOwner {
      require(!finalised);
      require(_minFrames <= maxFrames);
      require(maxFrames.mod(_minFrames) == 0);
      emit MinFramesUpdated(minFrames, _minFrames);
      minFrames = _minFrames;
  }
  function setFrameUsd(uint256 _frameUsd) public onlyOwner {
      require(!finalised);
      require(_frameUsd > 0);
      emit FrameUsdUpdated(frameUsd, _frameUsd);
      frameUsd = _frameUsd;
  }
  function setBonusOffList(uint256 _bonusOffList) public onlyOwner {
      require(!finalised);
      require(_bonusOffList <= 100);
      // some smarts for hitting softcap limit
      emit BonusOffListUpdated(bonusOffList, _bonusOffList);
      bonusOffList = _bonusOffList;
  }

  function symbol() public view returns (string memory _symbol) {
      _symbol = frameRushToken.symbol();
  }
  function name() public view returns (string memory _name) {
      _name = frameRushToken.name();
  }
  // ETH per USD from price feed
  // e.g., 171.123232454415 * 10^18
  function ethUsd() public view returns (uint256 _rate, bool _live) {
      return ethUsdPriceFeed.getRate();
  }
  // USD per frame, with bonus
  // e.g., 128.123412344122 * 10^18
  function frameUsdWithBonus() public view returns (uint256 _rate) {
      _rate = frameUsd.mul(100).div(bonusOffList.add(100));
  }
  // ETH per frame, e.g., 2.757061128879679264 * 10^18
  function frameEth() public view returns (uint256 _rate, bool _live) {
      uint256 _ethUsd;
      (_ethUsd, _live) = ethUsd();
      if (_live) {
          _rate = frameUsdWithBonus().mul(TENPOW18).div(_ethUsd);
      }
  }

  function framesRemaining() public view returns (uint256) {
    return maxFrames.sub(framesSold);
  }
  function pctSold() public view returns (uint256) {
    return framesSold.mul(100).div(maxFrames);
  }
  function pctRemaining() public view returns (uint256) {
    return maxFrames.sub(framesSold).mul(100).div(maxFrames);
  }

  function lockedAccountThresholdEth() public view returns (uint256 _amount) {
    uint256 _ethUsd;
    bool _live;
    (_ethUsd, _live) = ethUsd();
    require(_live);
    return lockedAccountThresholdUsd.mul(TENPOW18).div(_ethUsd);
  }
  function hardCapEth() public view returns (uint256) {
    uint256 _ethUsd;
    bool _live;
    (_ethUsd, _live) = ethUsd();
    require(_live);
    return hardCapUsd.mul(TENPOW18).mul(TENPOW18).div(_ethUsd);
  }
  function softCapEth() public view returns (uint256) {
    uint256 _ethUsd;
    bool _live;
    (_ethUsd, _live) = ethUsd();
    require(_live);
    return softCapUsd.mul(TENPOW18).mul(TENPOW18).div(_ethUsd);
  }

  function calculateFrames(uint256 ethAmount) public view returns (uint256 frames, uint256 ethToTransfer) {
    // Get frameEth rate including any bonuses
    uint256 _frameEth;
    bool _live;
    (_frameEth, _live) = frameEth();
    require(_live);
    // Factor in hard cap
    uint256 _hardCapEth = hardCapEth();
    require(contributedEth < _hardCapEth);
    if (contributedEth.add(ethAmount) >= _hardCapEth) {
        ethAmount = _hardCapEth.sub(contributedEth);
    }
    // Get number of frames available to be purchased
    frames = ethAmount.div(_frameEth);
    // Get number of frames available to be purchased
    if (framesSold.add(frames) >= maxFrames) {
        frames = maxFrames.sub(framesSold);
    }
    frames = frames.div(minFrames).mul(minFrames);
    ethToTransfer = frames.mul(_frameEth);
  }

  function calculateRoyaltyFrames(uint256 ethAmount) public view returns (uint256 frames, uint256 ethToTransfer) {
      (frames, ethToTransfer) = calculateFrames(ethAmount);

  }

  function () external payable {
    // require(now >= startDate && now <= endDate);

    // Get number of frames, will revert if sold out
    uint256 ethToTransfer;
    uint256 frames;
    (frames, ethToTransfer) = calculateFrames( msg.value);

    // Update crowdsale state
    contributedEth = contributedEth.add(ethToTransfer);
    accountEthAmount[msg.sender] = accountEthAmount[msg.sender].add(ethToTransfer);

    // Accept Payments
    uint256 ethToRefund = msg.value.sub(ethToTransfer);
    if (ethToTransfer > 0) {
        wallet.transfer(ethToTransfer);
    }
    if (ethToRefund > 0) {
        msg.sender.transfer(ethToRefund);
    }
    // Distribute tokens
    claimFrames(msg.sender,frames);
    emit Purchased(msg.sender, frames, ethToTransfer, framesSold, contributedEth);
  }

  // Contract owner allocates frames to tokenOwner
  function claimFrames(address tokenOwner, uint256 frames) internal  {
      require(!finalised);
      require(frames > 0);
      // Tokens locked and KYC check required if over AccountThresholdEth
      bool lockAccount = accountEthAmount[tokenOwner] > lockedAccountThresholdEth();
      // Issue frameRush tokens
      require(frameRushToken.mint(tokenOwner, frames.mul(TENPOW18), lockAccount));
      framesSold = framesSold.add(frames);
      if (framesSold >= maxFrames) {
          finalised = true;
      }
  }

  // Contract owner allocates frames to tokenOwner
  function claimRoyaltyFrames(address tokenOwner, uint256 frames, uint256 ethToTransfer) external  {
      require(!finalised);
      require(msg.sender == royaltyCrowdsaleAddress);
      // Also get the amount contributed
      require(framesSold.add(frames) <= maxFrames);
      contributedEth = contributedEth.add(ethToTransfer);

      // Mint token lock = true, until they are certified as investors
      require(royaltyToken.mint(tokenOwner, frames.mul(TENPOW18), true));
      claimFrames(tokenOwner,frames);
      emit Purchased(tokenOwner, frames, 0, framesSold, contributedEth);
  }

  // Contract owner allocates frames to tokenOwner for offline purchase

  function offlineFramesPurchase(address tokenOwner, uint256 frames) external onlyOperator {
      require(!finalised);
      require(frames > 0);
      require(framesSold.add(frames) <= maxFrames);
      (uint256 _frameEth, bool _live) = frameEth();
      require(_live);
      uint256 ethToTransfer = frames.mul(_frameEth);
      contributedEth = contributedEth.add(ethToTransfer);
      accountEthAmount[tokenOwner] = accountEthAmount[tokenOwner].add(ethToTransfer);
      claimFrames(tokenOwner,frames);
      emit Purchased(tokenOwner, frames, 0, framesSold, contributedEth);
  }

  // Contract owner finalises to disable frame minting
  function finalise() public onlyOwner {
      require(!finalised || frameRushToken.mintable());
      require(now > endDate || framesSold >= maxFrames);

      finalised = true;
      frameRushToken.disableMinting();
      require(royaltyToken.mint(owner, producerFrames.mul(TENPOW18), true));
      royaltyToken.disableMinting();
  }

}

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
    uint256 public startDate;
    uint256 public endDate;
    event Purchased(address indexed addr, uint256 frames, uint256 ethToTransfer, uint256 royaltiesSold, uint256 contributedEth);
    event SetFrameCrowdsale(address oldCrowdsaleContract, address newCrowdsaleContract);
    event WalletUpdated(address indexed oldWallet, address indexed newWallet);
    event MaxRoyaltyFramesUpdated(uint256 oldMaxRoyaltyFrames,  uint256 newMaxRoyaltyFrames);

    constructor(address payable _wallet, address _crowdsaleContract, uint256 _startDate, uint256 _endDate, uint256 _maxRoyaltyFrames) public {
      require(_wallet != address(0));
      require(_crowdsaleContract != address(0));
      require(_endDate > _startDate);
      // require(_startDate >= now);
      wallet = _wallet;
      startDate = _startDate;
      endDate = _endDate;
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
        // require(now >= startDate && now <= endDate);
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
// import "../DreamFramesToken/DreamFramesToken.sol";
// import "../RoyaltyToken/DividendToken.sol";


contract ITokenFactory {
    function deployTokenContract(address owner, string memory symbol, string memory name, uint8 decimals, uint totalSupply, bool mintable, bool transferable) public  returns (address);
}

contract IRoyaltyTokenFactory {
    function deployRoyaltyTokenContract(address owner, string memory symbol, string memory name, uint8 decimals, uint totalSupply, bool mintable, bool transferable, address whitelist) public  returns (address);
}


// ----------------------------------------------------------------------------
// House Factory
// ----------------------------------------------------------------------------
contract DreamFramesFactory is Operated {

    mapping(address => bool) _verify;
    address[] public deployedFanTokens;
    address[] public deployedRoyaltyTokens;
    DreamFramesCrowdsale[] public deployedTokenCrowdsales;
    DreamFramesRoyaltyCrowdsale[] public deployedRoyaltyCrowdsales;

    address public whiteList;
    address public priceFeed;
    ITokenFactory public tokenFactory;
    IRoyaltyTokenFactory public royaltyTokenFactory;

    event WhiteListUpdated(address indexed oldWhiteList, address indexed newWhiteList);
    event PriceFeedUpdated(address indexed oldPriceFeed, address indexed newPriceFeed);
    event TokenFactoryUpdated(address indexed oldTokenFactory, address indexed newTokenFactory);
    event RoyaltyTokenFactoryUpdated(address indexed oldRoyaltyTokenFactory, address indexed newRoyaltyTokenFactory);

    // AG - to be updated
    // event TokenContractsDeployed(address indexed movie, string movieName, address indexed token, string tokenSymbol, string tokenName, uint8 tokenDecimals, address indexed housemateName, uint tokensForNewHousemates);
    event CrowdsaleContractsDeployed( address indexed token, address indexed royaltyToken, address wallet);

    constructor() public {
        super.initOperated(msg.sender);
    }

    // Setter functions
    function setWhiteList(address _whiteList) public onlyOwner {
        require(_whiteList != address(0));
        emit WhiteListUpdated(whiteList, _whiteList);
        whiteList = _whiteList;
    }
    function setTokenFactory(address _tokenFactory) public onlyOwner {
        require(_tokenFactory != address(0));
        emit TokenFactoryUpdated(address(tokenFactory), _tokenFactory);
        tokenFactory = ITokenFactory(_tokenFactory);
    }
    function setRoyaltyTokenFactory(address _royaltyTokenFactory) public onlyOwner {
        require(_royaltyTokenFactory != address(0));
        emit RoyaltyTokenFactoryUpdated(address(royaltyTokenFactory), _royaltyTokenFactory);
        royaltyTokenFactory = IRoyaltyTokenFactory(_royaltyTokenFactory);
    }
    function setPriceFeed(address _priceFeed) public onlyOwner {
        require(_priceFeed != address(0));
        emit WhiteListUpdated(priceFeed, _priceFeed);
        priceFeed = _priceFeed;
    }

    // Deployment functions
    function deployTokenContract(
        address owner,
        string memory name,
        string memory  symbol,
        uint8 decimals,
        uint256 totalSupply,
        bool mintable,
        bool transferable
    ) public onlyOwner returns (address token) {
        token = tokenFactory.deployTokenContract(
                                    owner,
                                    symbol,
                                    name,
                                    decimals,
                                    totalSupply,
                                    mintable,
                                    transferable
                                );
        _verify[address(token)] = true;
        deployedFanTokens.push(token);

    }

    // Deployment functions
    function deployRoyaltyTokenContract(
        address _owner,
        string memory _symbol,
        string memory _name,
        uint8 _decimals,
        uint256 _totalSupply,
        bool _mintable,
        bool _transferable
    ) public onlyOwner returns (address royaltyToken) {
        royaltyToken = royaltyTokenFactory.deployRoyaltyTokenContract(
                                    _owner, 
                                    _symbol,
                                    _name,
                                    _decimals,
                                    _totalSupply,
                                    _mintable,
                                    _transferable,
                                    whiteList
                                );
        _verify[address(royaltyToken)] = true;
        deployedRoyaltyTokens.push(royaltyToken);

    }

    function deployCrowdsaleContracts(
        address royalty,
        address token,
        address payable wallet,
        uint256 startDate,
        uint256 endDate,
        uint256 minFrames,
        uint256 maxFrames,
        uint256 maxRoyaltyFrames,
        uint256 producerFrames,
        uint256 frameUsd,
        uint256 bonusOffList,
        uint256 hardCapUsd,
        uint256 softCapUsd
    ) public onlyOwner returns (DreamFramesCrowdsale crowdsale , DreamFramesRoyaltyCrowdsale royaltyCS ) {
        // Deploy Crowdsale contract
        crowdsale = new DreamFramesCrowdsale(token,royalty, priceFeed, whiteList);
        crowdsale.init(wallet, startDate, endDate, minFrames, maxFrames, producerFrames, frameUsd, bonusOffList, hardCapUsd, softCapUsd);
        // Deploy Royalty Crowdsale
        royaltyCS = new DreamFramesRoyaltyCrowdsale(wallet, address(crowdsale), startDate, endDate, maxRoyaltyFrames);
        // Set operators 
        royaltyCS.setFrameCrowdsaleContract(address(crowdsale));
        crowdsale.setRoyaltyCrowdsale(address(royaltyCS));

        _verify[address(crowdsale)] = true;
        deployedTokenCrowdsales.push(crowdsale);      
        _verify[address(royaltyCS)] = true;
        deployedRoyaltyCrowdsales.push(royaltyCS);
        emit CrowdsaleContractsDeployed(address(royalty), address(token), wallet);
    }

    // Counter functions
    function verify(address addr) public view returns (bool valid) {
        valid = _verify[addr];
    }
    function numberOfDeployedFanTokens() public view returns (uint) {
        return deployedFanTokens.length;
    }
    function numberOfDeployedRoyaltyTokens() public view returns (uint) {
        return deployedRoyaltyTokens.length;
    }
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
    function () external payable {
        revert();
    }
}
