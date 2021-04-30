pragma solidity ^0.6.12;

// ----------------------------------------------------------------------------
// BokkyPooBah's Token Teleportation Service Interface v1.20
//
// https://github.com/bokkypoobah/BokkyPooBahsTokenTeleportationServiceSmartContract
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------

import "../interfaces/ERC20Interface.sol";

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
