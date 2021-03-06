pragma solidity ^0.6.12;


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
import "../Shared/BTTSTokenInterface120.sol";
import "../Shared/BTTSTokenLibrary120.sol";
import "./WhiteListInterface.sol";


// ----------------------------------------------------------------------------
// BokkyPooBah's Token Teleportation Service Token v1.20
//
// https://github.com/bokkypoobah/BokkyPooBahsTokenTeleportationServiceSmartContract
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------
contract DividendToken is BTTSTokenInterface {
    using BTTSLib for BTTSLib.Data;
    using BTTSLib for uint256;

    BTTSLib.Data data;
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


    function owner() public view returns (address) {
       return data.owner;
    }
    function newOwner() public view returns (address) {
       return data.newOwner;
    }
    function transferOwnership(address _newOwner) public {
       data.transferOwnership(_newOwner);
    }
    function acceptOwnership() public {
       data.acceptOwnership();
    }
    function transferOwnershipImmediately(address _newOwner) public {
       data.transferOwnershipImmediately(_newOwner);
    }

    // ------------------------------------------------------------------------
    // Token
    // ------------------------------------------------------------------------
    function symbol() public view returns (string memory) {
       return data.symbol;
    }
    function name() public view returns (string memory) {
       return data.name;
    }
    function decimals() public view returns (uint8) {
       return data.decimals;
    }

    // ------------------------------------------------------------------------
    // Minting and management
    // ------------------------------------------------------------------------
    function minter() public view returns (address) {
       return data.minter;
    }
    function setMinter(address _minter) public {
       data.setMinter(_minter);
    }
    function mint(address tokenOwner, uint tokens, bool lockAccount) public returns (bool success) {
      require(_canReceive(address(0x0),tokenOwner));
       return data.mint(tokenOwner, tokens, lockAccount);
    }
    function accountLocked(address tokenOwner) public view returns (bool) {
       return data.accountLocked[tokenOwner];
    }
    function unlockAccount(address tokenOwner) public {
       data.unlockAccount(tokenOwner);
    }
    function mintable() public view returns (bool) {
       return data.mintable;
    }
    function transferable() public view returns (bool) {
       return data.transferable;
    }
    function disableMinting() public {
       data.disableMinting();
    }
    function enableTransfers() public {
       data.enableTransfers();
    }
    function nextNonce(address spender) public view returns (uint) {
       return data.nextNonce[spender];
    }

    // ------------------------------------------------------------------------
    // Other functions
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
       return data.transferAnyERC20Token(tokenAddress, tokens);
    }


    // ------------------------------------------------------------------------
    // Token functions
    // ------------------------------------------------------------------------
    function totalSupply() public view returns (uint) {
       return data.totalSupply - data.balances[address(0)];
    }
    function balanceOf(address tokenOwner) public view returns (uint balance) {
       return data.balances[tokenOwner];
    }
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
       return data.allowed[tokenOwner][spender];
    }
    function transfer(address to, uint tokens) public returns (bool success) {
       // updateAccounts
       require(_canTransfer(msg.sender,to, tokens));
       return data.transfer(to, tokens);
    }
    function approve(address spender, uint tokens) public returns (bool success) {
       return data.approve(spender, tokens);
    }
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
       // updateAccounts
        require(_canTransfer(from,to, tokens));
       return data.transferFrom(from, to, tokens);
    }
    function approveAndCall(address spender, uint tokens, bytes memory _data) public returns (bool success) {
       return data.approveAndCall(spender, tokens, _data);
    }

    //------------------------------------------------------------------------
    // Transfer Restrictions
    //------------------------------------------------------------------------
    function _canTransfer(address from, address to, uint256 value) internal view returns (bool success) {
        if (data.transferable && _canSend(from,to) && _canReceive(from,to) ) {
            success = true;
        }
    }

    function _canReceive(address from, address to) internal view returns (bool success) {
        if (to != address(0) && whiteList.isInWhiteList(to) ) {
            success = true;
        }
    }
    function _canSend(address from, address to) internal view returns (bool success) {
        if (to != address(0) && whiteList.isInWhiteList(from) ) {
            success = true;
        }
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
    receive() external payable {
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
    function signedTransferHash(address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
        return data.signedTransferHash(tokenOwner, to, tokens, fee, nonce);
    }
    function signedTransferCheck(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public view returns (CheckResult result) {
        return data.signedTransferCheck(tokenOwner, to, tokens, fee, nonce, sig, feeAccount);
    }

    function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success) {
        require(_canTransfer(tokenOwner,to, tokens));
        return data.signedTransfer(tokenOwner, to, tokens, fee, nonce, sig, feeAccount);
    }
    function signedApproveHash(address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
        return data.signedApproveHash(tokenOwner, spender, tokens, fee, nonce);
    }
    function signedApproveCheck(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public view returns (CheckResult result) {
        return data.signedApproveCheck(tokenOwner, spender, tokens, fee, nonce, sig, feeAccount);
    }
    function signedApprove(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success) {
        return data.signedApprove(tokenOwner, spender, tokens, fee, nonce, sig, feeAccount);
    }
    function signedTransferFromHash(address spender, address from, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
        return data.signedTransferFromHash(spender, from, to, tokens, fee, nonce);
    }
    function signedTransferFromCheck(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public view returns (CheckResult result) {
        return data.signedTransferFromCheck(spender, from, to, tokens, fee, nonce, sig, feeAccount);
    }
    function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success) {
        require(_canTransfer(from,to, tokens));
        return data.signedTransferFrom(spender, from, to, tokens, fee, nonce, sig, feeAccount);
    }
    function signedApproveAndCallHash(address tokenOwner, address spender, uint tokens, bytes memory _data, uint fee, uint nonce) public view returns (bytes32 hash) {
        return data.signedApproveAndCallHash(tokenOwner, spender, tokens, _data, fee, nonce);
    }
    function signedApproveAndCallCheck(address tokenOwner, address spender, uint tokens, bytes memory _data, uint fee, uint nonce, bytes memory sig, address feeAccount) public view returns (CheckResult result) {
        return data.signedApproveAndCallCheck(tokenOwner, spender, tokens, _data, fee, nonce, sig, feeAccount);
    }
    function signedApproveAndCall(address tokenOwner, address spender, uint tokens, bytes memory _data, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success) {
        return data.signedApproveAndCall(tokenOwner, spender, tokens, _data, fee, nonce, sig, feeAccount);
    }


}
