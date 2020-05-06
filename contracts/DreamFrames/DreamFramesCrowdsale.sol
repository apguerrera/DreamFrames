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
import "../../interfaces/BTTSTokenInterface120.sol";
import "../../interfaces/PriceFeedInterface.sol";
import "../../interfaces/WhiteListInterface.sol";

// ----------------------------------------------------------------------------
// DreamFramesToken Crowdsale Contract
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
    event BonusListUpdated(address oldBonusList, address newBonusList);

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
        //maxFrames = _maxFrames;
        producerFrames = _producerFrames;
        bonusOffList = _bonusOffList;
        bonusOnList = _bonusOnList;

    }


    // ----------------------------------------------------------------------------
    // Setter functions
    // ----------------------------------------------------------------------------

    function setWallet(address payable _wallet) public  {
        require(msg.sender == owner);         // dev: Not owner
        require(!finalised);                  // dev: Finalised
        require(_wallet != address(0));
        emit WalletUpdated(wallet, _wallet);
        wallet = _wallet;
    }
    function setStartDate(uint256 _startDate) public  {
        require(msg.sender == owner);         // dev: Not owner
        require(!finalised);                  // dev: Finalised
        require(_startDate >= now);
        emit StartDateUpdated(startDate, _startDate);
        startDate = _startDate;
    }
    function setEndDate(uint256 _endDate) public  {
        require(msg.sender == owner);         // dev: Not owner
        require(!finalised);                  // dev: Finalised
        require(_endDate > startDate);
        emit EndDateUpdated(endDate, _endDate);
        endDate = _endDate;
    }
    function setMaxFrames(uint256 _maxFrames) public  {
        require(msg.sender == owner);         // dev: Not owner
        require(!finalised);                  // dev: Finalised
        require(_maxFrames >= framesSold);
        require(_maxFrames.mod(minFrames) == 0);
        emit MaxFramesUpdated(maxFrames, _maxFrames);
        maxFrames = _maxFrames;
    }
    function setMinFrames(uint256 _minFrames) public  {
        require(msg.sender == owner);         // dev: Not owner
        require(!finalised);                  // dev: Finalised
        require(_minFrames <= maxFrames);
        require(maxFrames.mod(_minFrames) == 0);
        emit MinFramesUpdated(minFrames, _minFrames);
        minFrames = _minFrames;
    }
    function setFrameUsd(uint256 _frameUsd) public  {
        require(msg.sender == owner);         // dev: Not owner
        require(!finalised);                  // dev: Finalised
        require(_frameUsd > 0);
        emit FrameUsdUpdated(frameUsd, _frameUsd);
        frameUsd = _frameUsd;
    }
    function setBonusOffList(uint256 _bonusOffList) public  {
        require(msg.sender == owner);         // dev: Not owner
        require(!finalised);                  // dev: Finalised
        require(_bonusOffList <= 100);
        // some smarts for hitting softcap limit
        emit BonusOffListUpdated(bonusOffList, _bonusOffList);
        bonusOffList = _bonusOffList;
    }
    function setBonusOnList(uint256 _bonusOnList) public  {
        require(msg.sender == owner);         // dev: Not owner 
        require(!finalised);                  // dev: Finalised
        require(_bonusOnList <= 100);
        // cannot exceed diff between soft and hard caps
        emit BonusOnListUpdated(bonusOnList, _bonusOnList);
        bonusOnList = _bonusOnList;
    }
    function setBonusList(address _bonusList) public  {
        require(msg.sender == owner);         // dev: Not owner
        require(!finalised);                  // dev: Finalised
        emit BonusListUpdated(address(bonusList), _bonusList);

        bonusList = WhiteListInterface(_bonusList);
    }


    // ----------------------------------------------------------------------------
    // Getter functions
    // ----------------------------------------------------------------------------

    function symbol() public view returns (string memory _symbol) {
        _symbol = dreamFramesToken.symbol();
    }
    function name() public view returns (string memory _name) {
        _name = dreamFramesToken.name();
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

    // ETH per USD from price feed
    // e.g., 171.123232454415 * 10^18
    function ethUsd() public view returns (uint256 _rate, bool _live) {
        return ethUsdPriceFeed.getRate();
    }

    // ETH per frame, e.g., 2.757061128879679264 * 10^18
    function frameEth() public view returns (uint256 _rate, bool _live) {
        uint256 _ethUsd;
        (_ethUsd, _live) = ethUsd();
        if (_live) {
            _rate = frameUsd.mul(TENPOW18).div(_ethUsd);
        }
    }

    // ETH per frame, e.g., 2.757061128879679264 * 10^18 - including any bonuses
    function frameEthBonus(address _address) public view returns (uint256 _rate, bool _live) {
        uint256 _ethUsd;
        (_ethUsd, _live) = ethUsd();
        if (_live) {
            _rate = frameUsdWithBonus(_address).mul(TENPOW18).div(_ethUsd);
        }
    }

    function usdRemaining() public view returns (uint256) {
        return hardCapUsd.sub(contributedUsd);
    }
    function pctSold() public view returns (uint256) {
        return contributedUsd.mul(100).div(hardCapUsd);
    }
    function pctRemaining() public view returns (uint256) {
        return hardCapUsd.sub(contributedUsd).mul(100).div(hardCapUsd);
    }
    function calculateFrames(uint256 _ethAmount) public view returns (uint256 frames, uint256 ethToTransfer) {
        return calculateEthFrames(_ethAmount, msg.sender);
    }

    function calculateUsdFrames(uint256 _usdAmount, address _tokenOwner) public view returns (uint256 frames, uint256 usdToTransfer) {
        usdToTransfer = _usdAmount;
        if (contributedUsd.add(usdToTransfer) >= hardCapUsd) {
            usdToTransfer = hardCapUsd.sub(contributedUsd);
        }

        // Get number of frames available to be purchased
        frames = usdToTransfer.div(frameUsdWithBonus(_tokenOwner));

    }

    // Get frameEth rate including any bonuses
    function calculateEthFrames(uint256 _ethAmount, address _tokenOwner) public view returns (uint256 frames, uint256 ethToTransfer) {
        uint256 _frameEth;
        uint256 _ethUsd;
        bool _live;
        (_ethUsd, _live) = ethUsd();
        require(_live);                   // dev: Pricefeed not live
        (_frameEth, _live) = frameEthBonus(_tokenOwner);
        require(_live);                   // dev: Pricefeed not live

        // USD able to be spent on available frames
        uint256 usdAmount = _ethAmount.mul(_ethUsd).div(TENPOW18);
        (frames, usdAmount) = calculateUsdFrames(usdAmount,_tokenOwner);

        // Return ETH required for available frames
        ethToTransfer = frames.mul(_frameEth);
    }


    // ----------------------------------------------------------------------------
    // Crowd sale payments
    // ----------------------------------------------------------------------------

    // Buy FrameTokens by sending ETH to this contract address 
    function () external payable {
        buyFramesEth();
    }

    // Or calling this function and sending ETH 
    function buyFramesEth() public payable {
        // require(now >= startDate && now <= endDate);

        // Get number of frames remaining
        uint256 ethToTransfer;
        uint256 frames;
        (frames, ethToTransfer) = calculateEthFrames( msg.value, msg.sender);

        // Accept ETH Payments
        uint256 ethToRefund = msg.value.sub(ethToTransfer);
        if (ethToTransfer > 0) {
            wallet.transfer(ethToTransfer);
        }

        // Return any ETH to be refunded
        if (ethToRefund > 0) {
            msg.sender.transfer(ethToRefund);
        }

        // Claim FrameTokens
        claimFrames(msg.sender,frames);
        emit Purchased(msg.sender, frames, ethToTransfer, framesSold, contributedUsd);
    }


    // Operator allocates frames to tokenOwner for offchain purchases
    function offlineFramesPurchase(address _tokenOwner, uint256 _frames) external  {
        // Only operator and owner can allocate frames offline
        require(operators[msg.sender] || owner == msg.sender);  // dev: Not operator

        claimFrames(_tokenOwner,_frames);
        emit Purchased(_tokenOwner, _frames, 0, framesSold, contributedUsd);
    }

    // Contract allocates frames to tokenOwner
    function claimFrames(address _tokenOwner, uint256 _frames) internal  {
        require(!finalised, "Sale Finalised");
        require(_frames > 0, "No claimable frames");

        // Update crowdsale state
        uint256 usdToTransfer = _frames.mul(frameUsdWithBonus(_tokenOwner));
        require(contributedUsd.add(usdToTransfer) <= hardCapUsd, "Exceeds Hardcap");
        contributedUsd = contributedUsd.add(usdToTransfer);

        // Tokens locked and KYC check required if over AccountThresholdUsd
        accountUsdAmount[_tokenOwner] = accountUsdAmount[_tokenOwner].add(usdToTransfer);
        bool lockAccount = accountUsdAmount[_tokenOwner] > lockedAccountThresholdUsd;
 
        // Mint FrameTokens 
        require(dreamFramesToken.mint(_tokenOwner, _frames.mul(TENPOW18), lockAccount));
        framesSold = framesSold.add(_frames);
        if (contributedUsd.add(frameUsd) >= hardCapUsd) {
            finalised = true;
        }
    }

    // Contract owner finalises crowdsale
    function finalise(address _producer) public  {
        require(msg.sender == owner);         // dev: Not owner
        require(!finalised || dreamFramesToken.mintable());
        require(now > endDate || contributedUsd.add(frameUsd) >= hardCapUsd);

        finalised = true;
        require(dreamFramesToken.mint(_producer, producerFrames.mul(TENPOW18), false));
        dreamFramesToken.disableMinting();

    }

}
