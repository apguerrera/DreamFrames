pragma solidity ^0.5.4;

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
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address payable public owner;
    address public newOwner;
    bool private initialised;

     event OwnershipTransferred(address indexed from, address indexed to);

    function initOwned(address  _owner) internal {
        require(!initialised);
        owner = address(uint160(_owner));
        initialised = true;
    }
    function transferOwnership(address _newOwner) public {
        require(msg.sender == owner);
        newOwner = _newOwner;
    }
    function acceptOwnership()  public  {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = address(uint160(newOwner));
        newOwner = address(0);
    }
    function transferOwnershipImmediately(address _newOwner) public {
        require(msg.sender == owner);
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
    function addOperator(address _operator) public  {
        require(msg.sender == owner);
        require(!operators[_operator]);
        operators[_operator] = true;
        emit OperatorAdded(_operator);
    }
    function removeOperator(address _operator) public  {
        require(msg.sender == owner);
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
     function accountLocked(address tokenOwner) public view returns (bool);

     function disableMinting() public;
     function enableTransfers() public;
     function mintable() public view returns (bool success);
     function transferable() public view returns (bool success);

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
    function add(address[] memory accounts) public ;
    function remove(address[] memory accounts) public ;
    function initWhiteList(address owner) public ;
    function transferOwnershipImmediately(address _newOwner) public;


}

// ----------------------------------------------------------------------------
// DreamFramesToken Contract
// ----------------------------------------------------------------------------
contract DreamFramesCrowdsale is Operated {
  using SafeMath for uint256;

  uint256 private constant TENPOW18 = 10 ** 18;

  BTTSTokenInterface public dreamFramesToken;
  PriceFeedInterface public ethUsdPriceFeed;
  WhiteListInterface public bonusList;

  address payable public wallet;
  uint256 public startDate;
  uint256 public endDate;
  uint256 public minFrames;
  uint256 public maxFrames;
  uint256 public producerFrames;
  uint256 public frameUsd;
  uint256 public framesSold;
  bool public finalised;
  uint256 public bonusOffList;
  uint256 public bonusOnList;
  uint256 public contributedUsd;
  uint256 public softCapUsd;
  uint256 public hardCapUsd;
  uint256 public lockedAccountThresholdUsd;

  mapping(address => uint256) public accountUsdAmount;

  event WalletUpdated(address indexed oldWallet, address indexed newWallet);
  event StartDateUpdated(uint256 oldStartDate, uint256 newStartDate);
  event EndDateUpdated(uint256 oldEndDate, uint256 newEndDate);
  event MaxFramesUpdated(uint256 oldMaxFrames, uint256 newMaxFrames);
  event MinFramesUpdated(uint256 oldMinFrames, uint256 newMinFrames);
  event FrameUsdUpdated(uint256 oldFrameUsd, uint256 newFrameUsd);
  event BonusOffListUpdated(uint256 oldBonusOffList, uint256 newBonusOffList);
  event BonusOnListUpdated(uint256 oldBonusOnList, uint256 newBonusOnList);

  event Purchased(address indexed addr, uint256 frames, uint256 ethToTransfer, uint256 framesSold, uint256 contributedUsd);

  constructor() public {

  }

  function init(address _dreamFramesToken, address _ethUsdPriceFeed, address payable _wallet, uint256 _startDate, uint256 _endDate, uint256 _minFrames, uint256 _maxFrames, uint256 _producerFrames, uint256 _frameUsd, uint256 _bonusOffList,uint256 _bonusOnList, uint256 _hardCapUsd, uint256 _softCapUsd) public {
      require(_wallet != address(0));
      require(_endDate > _startDate);
      // require(_startDate >= now);
      require(_maxFrames > 0 && _frameUsd > 0);
      require(_maxFrames > _minFrames);
      require(_maxFrames.mod(_minFrames) == 0);
      require(_dreamFramesToken != address(0));
      require(_ethUsdPriceFeed != address(0) );
      initOperated(msg.sender);
      dreamFramesToken = BTTSTokenInterface(_dreamFramesToken);
      ethUsdPriceFeed = PriceFeedInterface(_ethUsdPriceFeed);

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
      bonusOnList = _bonusOnList;

    //   require(hardCapUsd >= _maxFrames.mul(_frameUsd).div(TENPOW18));  
    //   require(softCapUsd <= _maxFrames.mul(frameUsdWithBonus(address(this))).div(TENPOW18) );
  }

  // Setter functions
  function setWallet(address payable _wallet) public  {
      require(msg.sender == owner);
      require(!finalised);
      require(_wallet != address(0));
      emit WalletUpdated(wallet, _wallet);
      wallet = _wallet;
  }
  function setStartDate(uint256 _startDate) public  {
      require(msg.sender == owner);
      require(!finalised);
      require(_startDate >= now);
      emit StartDateUpdated(startDate, _startDate);
      startDate = _startDate;
  }
  function setEndDate(uint256 _endDate) public  {
      require(msg.sender == owner);
      require(!finalised);
      require(_endDate > startDate);
      emit EndDateUpdated(endDate, _endDate);
      endDate = _endDate;
  }
  function setMaxFrames(uint256 _maxFrames) public  {
      require(msg.sender == owner);
      require(!finalised);
      require(_maxFrames >= framesSold);
      require(_maxFrames.mod(minFrames) == 0);
      emit MaxFramesUpdated(maxFrames, _maxFrames);
      maxFrames = _maxFrames;
  }
  function setMinFrames(uint256 _minFrames) public  {
      require(msg.sender == owner);
      require(!finalised);
      require(_minFrames <= maxFrames);
      require(maxFrames.mod(_minFrames) == 0);
      emit MinFramesUpdated(minFrames, _minFrames);
      minFrames = _minFrames;
  }
  function setFrameUsd(uint256 _frameUsd) public  {
      require(msg.sender == owner);
      require(!finalised);
      require(_frameUsd > 0);
      emit FrameUsdUpdated(frameUsd, _frameUsd);
      frameUsd = _frameUsd;
  }
  function setBonusOffList(uint256 _bonusOffList) public  {
      require(msg.sender == owner);
      require(!finalised);
      require(_bonusOffList <= 100);
      // some smarts for hitting softcap limit
      emit BonusOffListUpdated(bonusOffList, _bonusOffList);
      bonusOffList = _bonusOffList;
  }
  function setBonusOnList(uint256 _bonusOnList) public  {
      require(msg.sender == owner);
      require(!finalised);
      require(_bonusOnList <= 100);
      // cannot exceed diff between soft and hard caps
      emit BonusOnListUpdated(bonusOnList, _bonusOnList);
      bonusOnList = _bonusOnList;
  }
  function setBonusList(address _bonusList) public  {
      require(msg.sender == owner);
      require(!finalised);
      bonusList = WhiteListInterface(_bonusList);
  }

  function symbol() public view returns (string memory _symbol) {
      _symbol = dreamFramesToken.symbol();
  }
  function name() public view returns (string memory _name) {
      _name = dreamFramesToken.name();
  }

  // ETH per USD from price feed
  // e.g., 171.123232454415 * 10^18
  function ethUsd() public view returns (uint256 _rate, bool _live) {
      return ethUsdPriceFeed.getRate();
  }

  function getBonus(address _address) public view returns (uint256) {
      if (bonusList.isInWhiteList(_address) && bonusOnList > bonusOffList ) {
          return bonusOnList;
      }
      return bonusOffList;
  }

  // USD per frame, with bonus
  // e.g., 128.123412344122 * 10^18
  function frameUsdWithBonus(address _address) public view returns (uint256 _rate) {
      uint256 bonus = getBonus(_address); 
      _rate = frameUsd.mul(100).div(bonus.add(100));
  }

  // ETH per frame, e.g., 2.757061128879679264 * 10^18
  function frameEth() public view returns (uint256 _rate, bool _live) {
      uint256 _ethUsd;
      (_ethUsd, _live) = ethUsd();
      if (_live) {
          _rate = frameUsd.mul(TENPOW18).div(_ethUsd);
      }
  }

  // ETH per frame, e.g., 2.757061128879679264 * 10^18
  function frameEthBonus(address _address) public view returns (uint256 _rate, bool _live) {
      uint256 _ethUsd;
      (_ethUsd, _live) = ethUsd();
      if (_live) {
          _rate = frameUsdWithBonus(_address).mul(TENPOW18).div(_ethUsd);
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



  function calculateFrames(uint256 _ethAmount) public view returns (uint256 frames, uint256 ethToTransfer) {
      return calculateUserFrames(_ethAmount, msg.sender);
  }

  function calculateUserFrames(uint256 _ethAmount, address _tokenOwner) public view returns (uint256 frames, uint256 ethToTransfer) {
    // Get frameEth rate including any bonuses
    uint256 _frameEth;
    uint256 _ethUsd;
    bool _live;
    (_ethUsd, _live) = ethUsd();
    (_frameEth, _live) = frameEthBonus(_tokenOwner);
    require(_live);
    
    // USD able to be spent
    uint256 usdAmount = _ethAmount.mul(TENPOW18).div(_ethUsd);
    require(contributedUsd < hardCapUsd);
    if (contributedUsd.add(usdAmount) >= hardCapUsd) {
        usdAmount = hardCapUsd.sub(contributedUsd);
    }
    
    // Get number of frames available to be purchased
    frames = _ethAmount.div(_frameEth);
    if (framesSold.add(frames) >= maxFrames) {
        frames = maxFrames.sub(framesSold);
    }
    ethToTransfer = frames.mul(_frameEth);
  }


  function () external payable {
    // require(now >= startDate && now <= endDate);

    // Get number of frames, will revert if sold out
    uint256 ethToTransfer;
    uint256 frames;
    (frames, ethToTransfer) = calculateFrames( msg.value);

    // Update crowdsale state
    uint256 usdToTransfer = frames.mul(frameUsdWithBonus(msg.sender));
    contributedUsd = contributedUsd.add(usdToTransfer);

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
    emit Purchased(msg.sender, frames, ethToTransfer, framesSold, contributedUsd);
  }

  // Contract owner allocates frames to tokenOwner
  function claimFrames(address _tokenOwner, uint256 _frames) internal  {
      require(!finalised);
      require(_frames > 0);
      // Tokens locked and KYC check required if over AccountThresholdEth
      bool lockAccount = accountUsdAmount[_tokenOwner] > lockedAccountThresholdUsd;
      // Issue dreamFrames tokens
      require(dreamFramesToken.mint(_tokenOwner, _frames.mul(TENPOW18), lockAccount));
      framesSold = framesSold.add(_frames);
      if (framesSold >= maxFrames) {
          finalised = true;
      }
  }



  // Contract owner allocates frames to tokenOwner for offline purchase

  function offlineFramesPurchase(address tokenOwner, uint256 frames) external  {
      require(operators[msg.sender] || owner == msg.sender);
      require(!finalised);
      require(frames > 0);
      require(framesSold.add(frames) <= maxFrames);
      (uint256 _frameEth, bool _live) = frameEth();
      require(_live);

      uint256 usdToTransfer = frames.mul(frameUsdWithBonus(tokenOwner));
      contributedUsd = contributedUsd.add(usdToTransfer);
      accountUsdAmount[tokenOwner] = accountUsdAmount[tokenOwner].add(usdToTransfer);
      claimFrames(tokenOwner,frames);
      emit Purchased(tokenOwner, frames, 0, framesSold, contributedUsd);
  }

  // Contract owner finalises to disable frame minting
  function finalise(address _producer) public  {
      require(msg.sender == owner);
      require(!finalised || dreamFramesToken.mintable());
      require(now > endDate || framesSold >= maxFrames);

      finalised = true;
      require(dreamFramesToken.mint(_producer, producerFrames.mul(TENPOW18), false));
      dreamFramesToken.disableMinting();

  }

}
