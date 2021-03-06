 pragma solidity ^0.6.12;

// ----------------------------------------------------------------------------
// BokkyPooBah's Token Teleportation Service v1.10
//
// https://github.com/bokkypoobah/BokkyPooBahsTokenTeleportationServiceSmartContract
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------


// import "../Shared/BTTSTokenInterface120.sol";
import "../Shared/BTTSTokenLibrary120.sol";


// ----------------------------------------------------------------------------
// BokkyPooBah's Token Teleportation Service Token v1.10
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------
contract DreamFramesToken is BTTSTokenInterface {
    using BTTSLib for BTTSLib.Data;
    BTTSLib.Data data;

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    // AG: Should be external but required calldata
    function init(address owner, string calldata symbol, string calldata name, uint8 decimals, uint initialSupply, bool mintable, bool transferable) external  {
        data.init(owner, symbol, name, decimals, initialSupply, mintable, transferable);
    }

    // ------------------------------------------------------------------------
    // Ownership
    // ------------------------------------------------------------------------
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
    function symbol() public view override returns (string memory) {
        return data.symbol;
    }
    function name() public view override returns (string memory) {
        return data.name;
    }
    function decimals() public view override returns (uint8) {
        return data.decimals;
    }

    // ------------------------------------------------------------------------
    // Minting and management
    // ------------------------------------------------------------------------
    function minter() public view returns (address) {
        return data.minter;
    }
    function setMinter(address _minter) override public {
        data.setMinter(_minter);
    }
    function mint(address tokenOwner, uint tokens, bool lockAccount) public virtual override returns (bool success) {
        return data.mint(tokenOwner, tokens, lockAccount);
    }
    function accountLocked(address tokenOwner) public view override returns (bool) {
        return data.accountLocked[tokenOwner];
    }
    function unlockAccount(address tokenOwner) override public {
        data.unlockAccount(tokenOwner);
    }
    function mintable() public view override returns (bool) {
        return data.mintable;
    }
    function transferable() public view override returns (bool) {
        return data.transferable;
    }
    function disableMinting() override public {
        data.disableMinting();
    }
    function enableTransfers() override public {
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
    // Don't accept ethers
    // ------------------------------------------------------------------------
    receive() virtual external payable {
         revert();
    }

    // ------------------------------------------------------------------------
    // Token functions
    // ------------------------------------------------------------------------
    function totalSupply() public view override returns (uint) {
        return data.totalSupply - data.balances[address(0)];
    }
    function balanceOf(address tokenOwner) public view override returns (uint balance) {
        return data.balances[tokenOwner];
    }
    function allowance(address tokenOwner, address spender) public view override returns (uint remaining) {
        return data.allowed[tokenOwner][spender];
    }
    function transfer(address to, uint tokens) public virtual override returns (bool success) {
        return data.transfer(to, tokens);
    }
    function approve(address spender, uint tokens) public override returns (bool success) {
        return data.approve(spender, tokens);
    }
    function transferFrom(address from, address to, uint tokens) public virtual override returns (bool success) {
        return data.transferFrom(from, to, tokens);
    }
    function approveAndCall(address spender, uint tokens, bytes memory _data) public override returns (bool success) {
        return data.approveAndCall(spender, tokens, _data);
    }

    // ------------------------------------------------------------------------
    // Signed function
    // ------------------------------------------------------------------------
    function signedTransferHash(address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view override returns (bytes32 hash) {
        return data.signedTransferHash(tokenOwner, to, tokens, fee, nonce);
    }
    function signedTransferCheck(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public view override returns (CheckResult result) {
        return data.signedTransferCheck(tokenOwner, to, tokens, fee, nonce, sig, feeAccount);
    }
    function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public virtual override returns (bool success) {
        return data.signedTransfer(tokenOwner, to, tokens, fee, nonce, sig, feeAccount);
    }
    function signedApproveHash(address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view override returns (bytes32 hash) {
        return data.signedApproveHash(tokenOwner, spender, tokens, fee, nonce);
    }
    function signedApproveCheck(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public view override returns (CheckResult result) {
        return data.signedApproveCheck(tokenOwner, spender, tokens, fee, nonce, sig, feeAccount);
    }
    function signedApprove(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public override returns (bool success) {
        return data.signedApprove(tokenOwner, spender, tokens, fee, nonce, sig, feeAccount);
    }
    function signedTransferFromHash(address spender, address from, address to, uint tokens, uint fee, uint nonce) public view override returns (bytes32 hash) {
        return data.signedTransferFromHash(spender, from, to, tokens, fee, nonce);
    }
    function signedTransferFromCheck(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public view override returns (CheckResult result) {
        return data.signedTransferFromCheck(spender, from, to, tokens, fee, nonce, sig, feeAccount);
    }
    function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public virtual override returns (bool success) {
        return data.signedTransferFrom(spender, from, to, tokens, fee, nonce, sig, feeAccount);
    }
    function signedApproveAndCallHash(address tokenOwner, address spender, uint tokens, bytes memory _data, uint fee, uint nonce) public view override returns (bytes32 hash) {
        return data.signedApproveAndCallHash(tokenOwner, spender, tokens, _data, fee, nonce);
    }
    function signedApproveAndCallCheck(address tokenOwner, address spender, uint tokens, bytes memory _data, uint fee, uint nonce, bytes memory sig, address feeAccount) public view override returns (CheckResult result) {
        return data.signedApproveAndCallCheck(tokenOwner, spender, tokens, _data, fee, nonce, sig, feeAccount);
    }
    function signedApproveAndCall(address tokenOwner, address spender, uint tokens, bytes memory _data, uint fee, uint nonce, bytes memory sig, address feeAccount) public override returns (bool success) {
        return data.signedApproveAndCall(tokenOwner, spender, tokens, _data, fee, nonce, sig, feeAccount);
    }
}
