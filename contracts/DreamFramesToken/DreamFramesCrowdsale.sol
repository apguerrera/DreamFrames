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

import "../Shared/Operated.sol";
import "../Shared/SafeMath.sol";
import "../Shared/BTTSTokenInterface120.sol";
import "./PriceFeedInterface.sol";
import "../RoyaltyToken/WhiteListInterface.sol";

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
  uint256 public maxFrames;
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
  event FrameUsdUpdated(uint256 oldFrameUsd, uint256 newFrameUsd);
  event BonusOffListUpdated(uint256 oldBonusOffList, uint256 newBonusOffList);
  event Purchased(address indexed addr, uint256 frames, uint256 ethToTransfer, uint256 framesSold, uint256 contributedEth);
  event RoyaltyCrowdsaleUpdated(address indexed oldRoyaltyCrowdsaleAddress, address indexed  newRoyaltyCrowdsaleAddres);

  constructor(address _frameRushToken, address _royaltyToken, address _ethUsdPriceFeed,  address _whiteList, address payable _wallet, uint256 _startDate, uint256 _endDate, uint256 _maxFrames, uint256 _frameUsd, uint256 _bonusOffList, uint256 _hardCapUsd, uint256 _softCapUsd) public {
      require(_frameRushToken != address(0));
      require(_ethUsdPriceFeed != address(0) );
      require(_wallet != address(0));
      require(_startDate >= now && _endDate > _startDate);
      require(_maxFrames > 0 && _frameUsd > 0);
      initOperated(msg.sender);
      lockedAccountThresholdUsd = 10000;

      hardCapUsd = _hardCapUsd;
      softCapUsd = _softCapUsd;
      frameUsd = _frameUsd;
      wallet = _wallet;
      startDate = _startDate;
      endDate = _endDate;
      maxFrames = _maxFrames;
      bonusOffList = _bonusOffList;

      require(hardCapUsd >= _maxFrames.mul(_frameUsd).div(TENPOW18));
      require(softCapUsd <= _maxFrames.mul(frameUsdWithBonus()).div(TENPOW18) );
      frameRushToken = BTTSTokenInterface(_frameRushToken);
      royaltyToken = BTTSTokenInterface(_royaltyToken);
      ethUsdPriceFeed = PriceFeedInterface(_ethUsdPriceFeed);
      whiteList = WhiteListInterface(_whiteList);
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
      emit MaxFramesUpdated(maxFrames, _maxFrames);
      maxFrames = _maxFrames;
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
    if (framesSold.add(frames) >= maxFrames) {
        frames = maxFrames.sub(framesSold);
    }
    ethToTransfer = frames.mul(_frameEth);
  }

  function calculateRoyaltyFrames(uint256 ethAmount) public view returns (uint256 frames, uint256 ethToTransfer) {
      (frames, ethToTransfer) = calculateFrames(ethAmount);

  }

  function () external payable {
    require(now >= startDate && now <= endDate);

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
      require(!finalised);
      require(now > endDate || framesSold >= maxFrames);
      finalised = true;
  }

}
