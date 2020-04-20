pragma solidity ^0.5.4;


// ----------------------------------------------------------------------------
// DreamFrameDividendToken Contract
//
// Deployed to : {TBA}
//
// Enjoy.
//
// (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// (c) Adrian Guerrera / Deepyr Pty Ltd for Dreamframes 2019. The MIT Licence.
// ----------------------------------------------------------------------------
import "../DreamFramesToken/DreamFramesToken.sol";
import "./WhiteListInterface.sol";


// ----------------------------------------------------------------------------
// BokkyPooBah's Token Teleportation Service Token v1.20
//
// https://github.com/bokkypoobah/BokkyPooBahsTokenTeleportationServiceSmartContract
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------
contract RoyaltyToken is DreamFramesToken {
    using BTTSLib for uint256;

    WhiteListInterface public whiteList;

    // Dividends
    uint256 constant pointMultiplier = 10e32;
    ERC20Interface public dividendTokenAddress;
    uint256 public totalDividendPoints;
    uint256 public totalUnclaimedDividends;

    mapping(address => uint256) public lastEthPoints;
    mapping(address => uint256) public unclaimedDividendByAccount;

    // Dividend Events
    event DividendReceived(uint256 time, address indexed sender, uint256 amount);
    event WithdrawalDividends(address indexed holder, uint256 amount);
    event LogUint(uint256 amount, string msglog);


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    function init(address _owner, string calldata _symbol, string calldata _name, uint8 _decimals, uint _initialSupply, bool _mintable, bool _transferable, address _whiteList) external {
       data.init(_owner, _symbol, _name, _decimals, _initialSupply, _mintable, _transferable);
       whiteList = WhiteListInterface(_whiteList);
    }


    // ------------------------------------------------------------------------
    // Ownership
    // ------------------------------------------------------------------------
    modifier onlyOwner {
        require(msg.sender == data.owner);
        _;
    }

    // ------------------------------------------------------------------------
    // Minting and management
    // ------------------------------------------------------------------------
    function mint(address tokenOwner, uint tokens, bool lockAccount) public returns (bool success) {
      require(_canReceive(address(0x0),tokenOwner));
       return data.mint(tokenOwner, tokens, lockAccount);
    }

    // ------------------------------------------------------------------------
    // Token functions
    // ------------------------------------------------------------------------

    function transfer(address to, uint tokens) public returns (bool success) {
       _canTransfer(msg.sender,to, tokens);
       return data.transfer(to, tokens);
    }
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        _canTransfer(from,to, tokens);
       return data.transferFrom(from, to, tokens);
    }

    //------------------------------------------------------------------------
    // Transfer Restrictions
    //------------------------------------------------------------------------
    function _canTransfer (address from, address to, uint256 value) internal returns (bool success) {
        require(data.transferable);
        // Remove this check to conform to ERC20
        require(value > 0);
        require(_canReceive(from,to));
        require(_canSend(from,to));
        success = true;
    }

    function _canReceive(address from, address to) internal returns (bool success) {
        require(to != address(0));
        require(whiteList.isInWhiteList(to));
        // Set last points for sending to new accounts.
        if (data.balances[to] == 0 && lastEthPoints[to] == 0 && totalDividendPoints > 0) {
          lastEthPoints[to] = totalDividendPoints;
        }
        _updateAccount(to);
        success = true;
    }
    function _canSend(address from, address to) internal returns (bool success) {
        require(from != address(0));
        require(whiteList.isInWhiteList(from));
        _updateAccount(from);
        success = true;
    }

    //------------------------------------------------------------------------
    // Dividends
    //------------------------------------------------------------------------
    function dividendsOwing(address _account) external view returns(uint256) {
        return _dividendsOwing(_account);
    }
    function _dividendsOwing(address _account) internal view returns(uint256) {
        uint256 newDividendPoints = totalDividendPoints.safeSub(lastEthPoints[_account]);
        // Returns amount ETH owed from current token balance
        return (data.balances[_account] * newDividendPoints) / pointMultiplier;
    }

    //------------------------------------------------------------------------
    // Dividends: Token Transfers
    //------------------------------------------------------------------------
     function updateAccount(address _account) external {
        _updateAccount(_account);
    }
    function _updateAccount(address _account) internal {
       // Check if new deposits have been made since last withdraw
      if (lastEthPoints[_account] < totalDividendPoints ){
        uint256 _owing = _dividendsOwing(_account);
        // Increment internal dividends counter to new amount owed
        if (_owing > 0) {
            unclaimedDividendByAccount[_account] = unclaimedDividendByAccount[_account].safeAdd(_owing);
            lastEthPoints[_account] = totalDividendPoints;
        }
      }
    }

    //------------------------------------------------------------------------
    // Dividends: Token Deposits
    //------------------------------------------------------------------------

    function _depositDividends(uint256 _amount) internal {
      // Convert deposit into points
      totalDividendPoints += (_amount * pointMultiplier ) / totalSupply();
      totalUnclaimedDividends += _amount;
        emit DividendReceived(now, msg.sender, _amount);
    }

    function getLastEthPoints(address _account) external view returns (uint256) {
      return lastEthPoints[_account];
    }


    // ------------------------------------------------------------------------
    // Accept ETH deposits as dividends
    // ------------------------------------------------------------------------
    function () external payable {
        require(msg.value > 0);
        _depositDividends(msg.value);
    }

    //------------------------------------------------------------------------
    // Dividends: Claim accrued dividends
    //------------------------------------------------------------------------
    function withdrawDividends () external  {
        _updateAccount(msg.sender);
        _withdrawDividends(msg.sender);
    }
    function withdrawDividendsByAccount (address payable _account) external onlyOwner {
        _updateAccount(_account);
        _withdrawDividends(_account);
    }

    function _withdrawDividends(address payable _account) internal  {
        if (unclaimedDividendByAccount[_account]>0) {
          uint256 _unclaimed = unclaimedDividendByAccount[_account];
          totalUnclaimedDividends = totalUnclaimedDividends.safeSub(_unclaimed);
          unclaimedDividendByAccount[_account] = 0;
          _transferDividendTokens(_account, _unclaimed );
          emit WithdrawalDividends(_account, _unclaimed);
        }
    }

    function _transferDividendTokens( address payable _account, uint _amount) internal   {
            require(_amount > 0);
            require(_account != address(0));
            _account.transfer(_amount);
    }

    // ------------------------------------------------------------------------
    // Signed function
    // ------------------------------------------------------------------------
    function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success) {
        require(_canTransfer(tokenOwner,to, tokens));
        return data.signedTransfer(tokenOwner, to, tokens, fee, nonce, sig, feeAccount);
    }

    function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success) {
        require(_canTransfer(from,to, tokens));
        return data.signedTransferFrom(spender, from, to, tokens, fee, nonce, sig, feeAccount);
    }

}
