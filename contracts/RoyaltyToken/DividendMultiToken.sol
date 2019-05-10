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
    // [account]
    mapping(address => uint256) public lastDivPoints;
    mapping(address => uint256) public lastEthPoints;
    ERC20Interface public dividendTokenAddress;
    // [token]
    mapping(address => uint256) public totalDividendPoints;
    mapping(address => uint256) public totalUnclaimedDividends;
    // [account][token]
    mapping(address => mapping(address => uint256)) public unclaimedDividendByAccount;

    // Dividend Events
    event DividendReceived(uint256 time, address indexed sender, address indexed token, uint256 amount);
    event WithdrawalDividends(address indexed holder, address indexed token, uint256 amount);
    event LogUint(uint256 amount, string msglog);


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(address _owner, string memory _symbol, string memory _name, uint8 _decimals, uint _initialSupply, bool _mintable, bool _transferable, address _whiteList) public {
       data.init(_owner, _symbol, _name, _decimals, _initialSupply, _mintable, _transferable);
       whiteList = WhiteListInterface(_whiteList);
       _initDividends();
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
      require(_canReceive(address(0),tokenOwner));
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
       _canTransfer(msg.sender,to, tokens);
       return data.transfer(to, tokens);
    }
    function approve(address spender, uint tokens) public returns (bool success) {
       return data.approve(spender, tokens);
    }
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
       _canTransfer(from,to, tokens);
       return data.transferFrom(from, to, tokens);
    }
    function approveAndCall(address spender, uint tokens, bytes memory _data) public returns (bool success) {
       return data.approveAndCall(spender, tokens, _data);
    }

    //------------------------------------------------------------------------
    // Transfer Restrictions
    //------------------------------------------------------------------------
    function _canTransfer (address from, address to, uint256 value) internal returns (bool success) {
        require(data.transferable);
        require(value > 0);
        require(_canSend(from,to));
        require(_canReceive(from,to));
        success = true;
    }

    function _canReceive(address from, address to) internal returns (bool success) {
        require(to != address(0));
        require(whiteList.isInWhiteList(to));
        // Set last points for sending to new accounts.
        if (data.balances[to] == 0 && lastEthPoints[to] == 0 && totalDividendPoints > 0) {
          lastEthPoints[to] = totalDividendPoints[address(0x0)];
        }
        if (data.balances[to] == 0 && lastDivPoints[to] == 0 && totalDividendPoints > 0) {
          lastEthPoints[to] = totalDividendPoints[address(0x0)];
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
    function dividendsOwing(address _account, address _token) external view returns(uint256) {
        return _dividendsOwing(_account, _token);
    }
    function _dividendsOwing(address _account, address _token) internal view returns(uint256) {
        uint256 lastPoints;
        if (_token == address(0x0)) {
              lastPoints = lastEthPoints[_account];
        } else if (_token == address(dividendTokenAddress)) {
              lastPoints = lastDivPoints[_account];
        }
        uint256 newDividendPoints = totalDividendPoints[address(_token)].safeSub(lastPoints);

        return (data.balances[_account] * newDividendPoints) / pointMultiplier;
    }

    //------------------------------------------------------------------------
    // Dividends: Token Transfers
    //------------------------------------------------------------------------
     function updateAccount(address _account) public {
        _updateAccount(_account);
    }
    function _updateAccount(address _account) internal {
       // Check if new deposits have been made since last withdraw
       if (lastDivPoints[_account] < totalDividendPoints[address(dividendTokenAddress)]) {
             _updateAccountByToken(_account,address(dividendTokenAddress));
             lastDivPoints[_account] = totalDividendPoints[address(dividendTokenAddress)]
       }
       if (lastEthPoints[_account] < totalDividendPoints[address(0x0)]) {
             _updateAccountByToken(_account,address(0x0));
             lastEthPoints[_account]  = totalDividendPoints[address(0x0)];
       }
    }
    function _updateAccountByToken(address _account, address _token) internal {
       uint256 _owing = _dividendsOwing(_account, _token);
       // Increment internal dividends counter to new amount owed
       if (_owing > 0) {
           unclaimedDividendByAccount[_account][_token] = unclaimedDividendByAccount[_account][_token].safeAdd(_owing);
       }
    }

    //------------------------------------------------------------------------
    // Dividends: Token Deposits
    //------------------------------------------------------------------------
    function depositTokenDividend(uint _amount) external  {
        require(_amount > 0 );
        // accept tokens
        require(ERC20Interface(dividendTokenAddress).transferFrom(msg.sender, address(this), _amount));
        _depositDividends(_amount, address(dividendTokenAddress));
    }
    function approveTokenDividend(uint _amount) external  {
        require(_amount > 0);
        require(ERC20Interface(dividendTokenAddress).approve(address(this), _amount));
    }
    function _depositDividends(uint256 _amount, address _token) internal {
      // Convert deposit into points
      totalDividendPoints[_token] += (_amount * pointMultiplier ) / totalSupply();
      totalUnclaimedDividends[_token] += _amount;
        emit DividendReceived(now, msg.sender, _token, _amount);
    }

    function getLastEthPoints(address _account) external view returns (uint256) {
      return lastEthPoints[_account];
    }

    function getLastDivPoints(address _account) external view returns (uint256){
      return lastDivPoints[_account];
    }

    // ------------------------------------------------------------------------
    // Accept ETH deposits as dividends
    // ------------------------------------------------------------------------
    function () external payable {
        require(msg.value > 0);
        _depositDividends(msg.value,address(0x0));
    }

    //------------------------------------------------------------------------
    // Dividends: Claim accrued dividends
    //------------------------------------------------------------------------
    function withdrawDividends () public  {
        _updateAccount(msg.sender);
         _withdrawDividends(msg.sender);
    }
    function withdrawDividendsByAccount (address payable _account) public onlyOwner {
        _updateAccount(_account);
        _withdrawDividends(_account);
    }

    function _withdrawDividends(address payable _account) internal  {
        if (unclaimedDividendByAccount[_account][address(dividendTokenAddress)]>0) {
          _withdrawDividendsByToken(_account, address(dividendTokenAddress));
        }
        if (unclaimedDividendByAccount[_account][address(0x0)]>0) {
          _withdrawDividendsByToken(_account, address(0x0));
        }
    }

    function _withdrawDividendsByToken(address payable _account, address _token) internal  {
        uint256 _unclaimed = unclaimedDividendByAccount[_account][address(_token)];

        totalUnclaimedDividends[_token] = totalUnclaimedDividends[_token].safeSub(_unclaimed);
        unclaimedDividendByAccount[_account][_token] = 0;
        _transferDividendTokens(_token,_account, _unclaimed );
        emit WithdrawalDividends(_account, _token, _unclaimed);
    }

    function _transferDividendTokens(address _token, address payable _account, uint _amount) internal   {
            // AG: transfer dividends owed, to be replaced
        if (_token == address(dividendTokenAddress)) {
              require(ERC20Interface(_token).transfer(_account, _amount));
        } else if (_token == address(0x0)) {
              _account.transfer(_amount));
        }
    }

    //------------------------------------------------------------------------
    // Dividends: Helper functions
    //------------------------------------------------------------------------
    function setDividendTokenAddress (address _token) public onlyOwner {
        require(_token != address(0));
        dividendTokenAddress = ERC20Interface(_token);
    }

    function _initDividends() internal {
        dividendTokenAddress = ERC20Interface(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
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
        // AG: Test BTTS if nessasary
        // require(_canTransfer(tokenOwner,spender, tokens));
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
        // AG: Test BTTS if nessasary
        // require(_canTransfer(tokenOwner,spender, tokens));
        return data.signedApproveAndCall(tokenOwner, spender, tokens, _data, fee, nonce, sig, feeAccount);
    }


}
