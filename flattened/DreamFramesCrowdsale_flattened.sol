pragma solidity ^0.6.12;

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

    modifier onlyOwner() {
        require(owner == msg.sender, "Owned: caller is not the owner");
        _;
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
interface ERC20Interface {
  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

  function totalSupply() external view returns (uint);
  function balanceOf(address tokenOwner) external view returns (uint balance);
  function allowance(address tokenOwner, address spender) external view returns (uint remaining);
  function transfer(address to, uint tokens) external returns (bool success);
  function approve(address spender, uint tokens) external returns (bool success);
  function transferFrom(address from, address to, uint tokens) external returns (bool success);
}

// ----------------------------------------------------------------------------
// Contracts that can have tokens approved, and then a function executed
// ----------------------------------------------------------------------------
interface ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) external;
}


// ----------------------------------------------------------------------------
// BokkyPooBah's Token Teleportation Service Interface v1.10
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------
interface BTTSTokenInterface is ERC20Interface {
/*   uint public constant bttsVersion = 120;

     bytes public constant signingPrefix = "\x19Ethereum Signed Message:\n32";
     bytes4 public constant signedTransferSig = "\x75\x32\xea\xac";
     bytes4 public constant signedApproveSig = "\xe9\xaf\xa7\xa1";
     bytes4 public constant signedTransferFromSig = "\x34\x4b\xcc\x7d";
     bytes4 public constant signedApproveAndCallSig = "\xf1\x6f\x9b\x53"; */

     event OwnershipTransferred(address indexed from, address indexed to);
     event MinterUpdated(address from, address to);
     event Mint(address indexed tokenOwner, uint tokens, bool lockAccount);
     event MintingDisabled();
     event TransfersEnabled();
     event AccountUnlocked(address indexed tokenOwner);

     function symbol() external view returns (string memory);
     function name() external view returns (string memory);
     function decimals() external view returns (uint8);

     function approveAndCall(address spender, uint tokens, bytes memory data) external returns (bool success);

     // ------------------------------------------------------------------------
     // signed{X} functions
     // ------------------------------------------------------------------------
     function signedTransferHash(address tokenOwner, address to, uint tokens, uint fee, uint nonce) external view returns (bytes32 hash);
     function signedTransferCheck(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) external view returns (CheckResult result);
     function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) external returns (bool success);

     function signedApproveHash(address tokenOwner, address spender, uint tokens, uint fee, uint nonce) external view returns (bytes32 hash);
     function signedApproveCheck(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) external view returns (CheckResult result);
     function signedApprove(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) external returns (bool success);

     function signedTransferFromHash(address spender, address from, address to, uint tokens, uint fee, uint nonce) external view returns (bytes32 hash);
     function signedTransferFromCheck(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) external view returns (CheckResult result);
     function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) external returns (bool success);

     function signedApproveAndCallHash(address tokenOwner, address spender, uint tokens, bytes memory _data, uint fee, uint nonce) external view returns (bytes32 hash);
     function signedApproveAndCallCheck(address tokenOwner, address spender, uint tokens, bytes memory _data, uint fee, uint nonce, bytes memory sig, address feeAccount) external view returns (CheckResult result);
     function signedApproveAndCall(address tokenOwner, address spender, uint tokens, bytes memory _data, uint fee, uint nonce, bytes memory sig, address feeAccount) external returns (bool success);

     function mint(address tokenOwner, uint tokens, bool lockAccount) external returns (bool success);
     function unlockAccount(address tokenOwner) external;
     function accountLocked(address tokenOwner) external view returns (bool);

     function disableMinting() external;
     function enableTransfers() external;
     function mintable() external view returns (bool success);
     function transferable() external view returns (bool success);

     function setMinter(address minter) external;

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
interface PriceFeedInterface {
    function getRate() external view returns (uint _rate, bool _live);
}

// ----------------------------------------------------------------------------
// Bonus List interface
// ----------------------------------------------------------------------------
interface WhiteListInterface {
    function isInWhiteList(address account) external view returns (bool);
    function add(address[] calldata accounts) external ;
    function remove(address[] calldata accounts) external ;
    function initWhiteList(address owner) external ;
    function transferOwnershipImmediately(address _newOwner) external;


}

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
    uint256 public producerPct;
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
    event FrameUsdUpdated(uint256 oldFrameUsd, uint256 newFrameUsd);
    event BonusOffListUpdated(uint256 oldBonusOffList, uint256 newBonusOffList);
    event BonusOnListUpdated(uint256 oldBonusOnList, uint256 newBonusOnList);
    event BonusListUpdated(address oldBonusList, address newBonusList);

    event Purchased(address indexed addr, uint256 frames, uint256 ethToTransfer, uint256 framesSold, uint256 contributedUsd);

    constructor() public {
    }

    /// @notice
    function init(address _dreamFramesToken, address _ethUsdPriceFeed, address payable _wallet, uint256 _startDate, uint256 _endDate, uint256 _producerPct, uint256 _frameUsd, uint256 _bonusOffList,uint256 _bonusOnList, uint256 _hardCapUsd, uint256 _softCapUsd) public {
        require(_wallet != address(0));
        require(_endDate > _startDate);
        require(_startDate >= now);
        require(_producerPct < 100);
        require(_dreamFramesToken != address(0));
        require(_ethUsdPriceFeed != address(0) );
        initOperated(msg.sender);
        dreamFramesToken = BTTSTokenInterface(_dreamFramesToken);
        ethUsdPriceFeed = PriceFeedInterface(_ethUsdPriceFeed);

        lockedAccountThresholdUsd = 10000;
        hardCapUsd = _hardCapUsd;
        softCapUsd = _softCapUsd;
        frameUsd = _frameUsd;
        wallet = _wallet;
        startDate = _startDate;
        endDate = _endDate;
        producerPct = _producerPct;
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
        require(_startDate >= now);           // dev: Already started
        emit StartDateUpdated(startDate, _startDate);
        startDate = _startDate;
    }
    function setEndDate(uint256 _endDate) public  {
        require(msg.sender == owner);         // dev: Not owner
        require(!finalised);                  // dev: Finalised
        require(endDate >= now);              // dev: Already ended
        require(_endDate > startDate);        // dev: End before the start
        emit EndDateUpdated(endDate, _endDate);
        endDate = _endDate;
    }
    function setFrameUsd(uint256 _frameUsd) public  {
        require(msg.sender == owner);         // dev: Not owner
        require(!finalised);                  // dev: Finalised
        require(_frameUsd > 0);               // dev: Frame eq 0
        emit FrameUsdUpdated(frameUsd, _frameUsd);
        frameUsd = _frameUsd;
    }
    function setBonusOffList(uint256 _bonusOffList) public  {
        require(msg.sender == owner);         // dev: Not owner
        require(!finalised);                  // dev: Finalised
        require(_bonusOffList < 100);         // dev: Bonus over 100
        emit BonusOffListUpdated(bonusOffList, _bonusOffList);
        bonusOffList = _bonusOffList;
    }
    function setBonusOnList(uint256 _bonusOnList) public  {
        require(msg.sender == owner);         // dev: Not owner
        require(!finalised);                  // dev: Finalised
        require(_bonusOnList < 100);          // dev: Bonus over 100
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
    function usdRemaining() public view returns (uint256) {
        return hardCapUsd.sub(contributedUsd);
    }
    function pctSold() public view returns (uint256) {
        return contributedUsd.mul(100).div(hardCapUsd);
    }
    function pctRemaining() public view returns (uint256) {
        return hardCapUsd.sub(contributedUsd).mul(100).div(hardCapUsd);
    }
    function getBonus(address _address) public view returns (uint256) {
        if (bonusList.isInWhiteList(_address) && bonusOnList > bonusOffList ) {
            return bonusOnList;
        }
        return bonusOffList;
    }

    /// @notice USD per frame, with bonus
    /// @dev e.g., 128.123412344122 * 10^18
    function frameUsdWithBonus(address _address) public view returns (uint256 _rate) {
        uint256 bonus = getBonus(_address);
        _rate = frameUsd.mul(100).div(bonus.add(100));
    }

    /// @notice USD per Eth from price feed
    /// @dev  e.g., 171.123232454415 * 10^18
    function ethUsd() public view returns (uint256 _rate, bool _live) {
        return ethUsdPriceFeed.getRate();
    }

    /// @dev ETH per frame, e.g., 2.757061128879679264 * 10^18
    function frameEth() public view returns (uint256 _rate, bool _live) {
        uint256 _ethUsd;
        (_ethUsd, _live) = ethUsd();
        if (_live) {
            _rate = frameUsd.mul(TENPOW18).div(_ethUsd);
        }
    }

    /// @dev ETH per frame, e.g., 2.757061128879679264 * 10^18 - including any bonuses
    function frameEthBonus(address _address) public view returns (uint256 _rate, bool _live) {
        uint256 _ethUsd;
        (_ethUsd, _live) = ethUsd();
        if (_live) {
            _rate = frameUsdWithBonus(_address).mul(TENPOW18).div(_ethUsd);
        }
    }

    function calculateFrames(uint256 _ethAmount) public view returns (uint256 frames, uint256 ethToTransfer) {
        return calculateEthFrames(_ethAmount, msg.sender);
    }

    function calculateUsdFrames(uint256 _usdAmount, address _tokenOwner) public view returns (uint256 frames, uint256 usdToTransfer) {
        usdToTransfer = _usdAmount;
        if (contributedUsd.add(usdToTransfer) > hardCapUsd) {
            usdToTransfer = hardCapUsd.sub(contributedUsd);
        }
        // Get number of frames available to be purchased
        frames = usdToTransfer.div(frameUsdWithBonus(_tokenOwner));

    }

    /// @notice Get frameEth rate including any bonuses
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

    /// @notice Buy FrameTokens by sending ETH to this contract address
    receive() external payable {
        buyFramesEth();
    }

    /// @notice Or calling this function and sending ETH
    function buyFramesEth() public payable {
        // Get number of frames remaining
        uint256 ethToTransfer;
        uint256 frames;
        (frames, ethToTransfer) = calculateEthFrames( msg.value, msg.sender);

        // Accept ETH Payments
        uint256 ethToRefund = msg.value.sub(ethToTransfer);
        if (ethToTransfer > 0) {
            wallet.transfer(ethToTransfer);
        }

        // Return any ETH to be refundedf
        if (ethToRefund > 0) {
            msg.sender.transfer(ethToRefund);
        }

        // Claim FrameTokens
        claimFrames(msg.sender,frames);
        emit Purchased(msg.sender, frames, ethToTransfer, framesSold, contributedUsd);
    }


    /// @notice Operator allocates frames to tokenOwner for offchain purchases
    function offlineFramesPurchase(address _tokenOwner, uint256 _frames) external  {
        // Only operator and owner can allocate frames offline
        require(operators[msg.sender] || owner == msg.sender);  // dev: Not operator

        claimFrames(_tokenOwner,_frames);
        emit Purchased(_tokenOwner, _frames, 0, framesSold, contributedUsd);
    }

    /// @notice Contract allocates frames to tokenOwner
    function claimFrames(address _tokenOwner, uint256 _frames) internal  {
        require(!finalised, "Sale Finalised");
        require(_frames > 0, "No frames available");
        require(now >= startDate && now <= endDate, "Sale ended");

        // Update crowdsale state
        uint256 usdToTransfer = _frames.mul(frameUsdWithBonus(_tokenOwner));
        require(contributedUsd.add(usdToTransfer) <= hardCapUsd, "Exceeds Hardcap");
        contributedUsd = contributedUsd.add(usdToTransfer);

        // Tokens locked and KYC check required if over AccountThresholdUsd
        accountUsdAmount[_tokenOwner] = accountUsdAmount[_tokenOwner].add(usdToTransfer);
        bool lockAccount = accountUsdAmount[_tokenOwner] > lockedAccountThresholdUsd;

        // Mint FrameTokens
        require(dreamFramesToken.mint(_tokenOwner, _frames.mul(TENPOW18), lockAccount)); // dev: Not Mintable
        framesSold = framesSold.add(_frames);
        if (contributedUsd >= hardCapUsd) {
            finalised = true;
        }
    }

    /// @notice Contract owner finalises crowdsale
    function finalise(address _producer) public  {
        require(msg.sender == owner);                            // dev: Not owner
        require(!finalised || dreamFramesToken.mintable());      // dev: Already Finalised
        require(now > endDate || contributedUsd >= hardCapUsd);  // dev: Not Finished

        finalised = true;
        uint256 totalFrames = framesSold.mul(100).div(uint256(100).sub(producerPct));
        uint256 producerFrames = totalFrames.sub(framesSold);

        if (producerFrames > 0 && contributedUsd >= softCapUsd ) {
            require(dreamFramesToken.mint(_producer, producerFrames.mul(TENPOW18), false)); // dev: Failed final mint
        }
        dreamFramesToken.disableMinting();

    }

}
