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
 pragma solidity ^0.6.12;

// ----------------------------------------------------------------------------
// BokkyPooBah's Token Teleportation Service v1.10
//
// https://github.com/bokkypoobah/BokkyPooBahsTokenTeleportationServiceSmartContract
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------


// import "../Shared/BTTSTokenInterface120.sol";

// ----------------------------------------------------------------------------
// BokkyPooBah's Token Teleportation Service v1.20
//
// https://github.com/bokkypoobah/BokkyPooBahsTokenTeleportationServiceSmartContract
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------


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
// BokkyPooBah's Token Teleportation Service Library v1.20
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------
library BTTSLib {
   struct Data {
       bool initialised;

       // Ownership
       address owner;
       address newOwner;

       // Minting and management
       address minter;
       bool mintable;
       bool transferable;
       mapping(address => bool) accountLocked;

       // Token
       string symbol;
       string name;
       uint8 decimals;
       uint totalSupply;
       mapping(address => uint) balances;
       mapping(address => mapping(address => uint)) allowed;
       mapping(address => uint) nextNonce;
   }


   // ------------------------------------------------------------------------
   // Constants
   // ------------------------------------------------------------------------
   uint public constant bttsVersion = 110;
   bytes public constant signingPrefix = "\x19Ethereum Signed Message:\n32";
   bytes4 public constant signedTransferSig = "\x75\x32\xea\xac";
   bytes4 public constant signedApproveSig = "\xe9\xaf\xa7\xa1";
   bytes4 public constant signedTransferFromSig = "\x34\x4b\xcc\x7d";
   bytes4 public constant signedApproveAndCallSig = "\xf1\x6f\x9b\x53";

   // ------------------------------------------------------------------------
   // Event
   // ------------------------------------------------------------------------
   event OwnershipTransferred(address indexed from, address indexed to);
   event MinterUpdated(address from, address to);
   event Mint(address indexed tokenOwner, uint tokens, bool lockAccount);
   event MintingDisabled();
   event TransfersEnabled();
   event AccountUnlocked(address indexed tokenOwner);
   event Transfer(address indexed from, address indexed to, uint tokens);
   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);


   // ------------------------------------------------------------------------
   // Initialisation
   // ------------------------------------------------------------------------
   function init(Data storage self, address owner, string memory symbol, string memory name, uint8 decimals, uint initialSupply, bool mintable, bool transferable) public {
       require(!self.initialised);
       self.initialised = true;
       self.owner = owner;
       self.symbol = symbol;
       self.name = name;
       self.decimals = decimals;
       if (initialSupply > 0) {
           self.balances[owner] = initialSupply;
           self.totalSupply = initialSupply;
           emit Mint(self.owner, initialSupply, false);
           emit Transfer(address(0), self.owner, initialSupply);
       }
       self.mintable = mintable;
       self.transferable = transferable;
   }

   // ------------------------------------------------------------------------
   // Safe maths, inspired by OpenZeppelin
   // ------------------------------------------------------------------------
   function safeAdd(uint a, uint b) internal pure returns (uint c) {
       c = a + b;
       require(c >= a);
   }
   function safeSub(uint a, uint b) internal pure returns (uint c) {
       require(b <= a);
       c = a - b;
   }
   function safeMul(uint a, uint b) internal pure returns (uint c) {
       c = a * b;
       require(a == 0 || c / a == b);
   }
   function safeDiv(uint a, uint b) internal pure returns (uint c) {
       require(b > 0);
       c = a / b;
   }

   // ------------------------------------------------------------------------
   // Ownership
   // ------------------------------------------------------------------------
   function transferOwnership(Data storage self, address newOwner) public {
       require(msg.sender == self.owner);
       self.newOwner = newOwner;
   }
   function acceptOwnership(Data storage self) public {
       require(msg.sender == self.newOwner);
       emit OwnershipTransferred(self.owner, self.newOwner);
       self.owner = self.newOwner;
       self.newOwner = address(0);
   }
   function transferOwnershipImmediately(Data storage self, address newOwner) public {
       require(msg.sender == self.owner);
       emit OwnershipTransferred(self.owner, newOwner);
       self.owner = newOwner;
       self.newOwner = address(0);
   }

   // ------------------------------------------------------------------------
   // Minting and management
   // ------------------------------------------------------------------------
   function setMinter(Data storage self, address minter) public {
       require(msg.sender == self.owner);
       require(self.mintable);
       emit MinterUpdated(self.minter, minter);
       self.minter = minter;
   }
   function mint(Data storage self, address tokenOwner, uint tokens, bool lockAccount) public returns (bool success) {
       require(self.mintable);
       require(msg.sender == self.minter || msg.sender == self.owner);
       if (lockAccount) {
           self.accountLocked[tokenOwner] = true;
       }
       self.balances[tokenOwner] = safeAdd(self.balances[tokenOwner], tokens);
       self.totalSupply = safeAdd(self.totalSupply, tokens);
       emit Mint(tokenOwner, tokens, lockAccount);
       emit Transfer(address(0), tokenOwner, tokens);
       return true;
   }
   function unlockAccount(Data storage self, address tokenOwner) public {
       require(msg.sender == self.owner);
       require(self.accountLocked[tokenOwner]);
       self.accountLocked[tokenOwner] = false;
       emit AccountUnlocked(tokenOwner);
   }
   function disableMinting(Data storage self) public {
       require(self.mintable);
       require(msg.sender == self.minter || msg.sender == self.owner);
       self.mintable = false;
       if (self.minter != address(0)) {
           emit MinterUpdated(self.minter, address(0));
           self.minter = address(0);
       }
       emit MintingDisabled();
   }
   function enableTransfers(Data storage self) public {
       require(msg.sender == self.owner);
       require(!self.transferable);
       self.transferable = true;
       emit TransfersEnabled();
   }

   // ------------------------------------------------------------------------
   // Other functions
   // ------------------------------------------------------------------------
   function transferAnyERC20Token(Data storage self, address tokenAddress, uint tokens) public returns (bool success) {
       require(msg.sender == self.owner);
       return ERC20Interface(tokenAddress).transfer(self.owner, tokens);
   }

   // ------------------------------------------------------------------------
   // ecrecover from a signature rather than the signature in parts [v, r, s]
   // The signature format is a compact form {bytes32 r}{bytes32 s}{uint8 v}.
   // Compact means, uint8 is not padded to 32 bytes.
   //
   // An invalid signature results in the address(0) being returned, make
   // sure that the returned result is checked to be non-zero for validity
   //
   // Parts from https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
   // ------------------------------------------------------------------------
   function ecrecoverFromSig(bytes32 hash, bytes memory sig) public pure returns (address recoveredAddress) {
       bytes32 r;
       bytes32 s;
       uint8 v;
       if (sig.length != 65) return address(0);
       assembly {
           r := mload(add(sig, 32))
           s := mload(add(sig, 64))
           // Here we are loading the last 32 bytes. We exploit the fact that 'mload' will pad with zeroes if we overread.
           // There is no 'mload8' to do this, but that would be nicer.
           v := byte(0, mload(add(sig, 96)))
       }
       // Albeit non-transactional signatures are not specified by the YP, one would expect it to match the YP range of [27, 28]
       // geth uses [0, 1] and some clients have followed. This might change, see https://github.com/ethereum/go-ethereum/issues/2053
       if (v < 27) {
         v += 27;
       }
       if (v != 27 && v != 28) return address(0);
       return ecrecover(hash, v, r, s);
   }

   // ------------------------------------------------------------------------
   // Get CheckResult message
   // ------------------------------------------------------------------------
   function getCheckResultMessage(Data storage /*self*/, BTTSTokenInterface.CheckResult result) public pure returns (string memory) {
       if (result == BTTSTokenInterface.CheckResult.Success) {
           return "Success";
       } else if (result == BTTSTokenInterface.CheckResult.NotTransferable) {
           return "Tokens not transferable yet";
       } else if (result == BTTSTokenInterface.CheckResult.AccountLocked) {
           return "Account locked";
       } else if (result == BTTSTokenInterface.CheckResult.SignerMismatch) {
           return "Mismatch in signing account";
       } else if (result == BTTSTokenInterface.CheckResult.InvalidNonce) {
           return "Invalid nonce";
       } else if (result == BTTSTokenInterface.CheckResult.InsufficientApprovedTokens) {
           return "Insufficient approved tokens";
       } else if (result == BTTSTokenInterface.CheckResult.InsufficientApprovedTokensForFees) {
           return "Insufficient approved tokens for fees";
       } else if (result == BTTSTokenInterface.CheckResult.InsufficientTokens) {
           return "Insufficient tokens";
       } else if (result == BTTSTokenInterface.CheckResult.InsufficientTokensForFees) {
           return "Insufficient tokens for fees";
       } else if (result == BTTSTokenInterface.CheckResult.OverflowError) {
           return "Overflow error";
       } else {
           return "Unknown error";
       }
   }

   // ------------------------------------------------------------------------
   // Token functions
   // ------------------------------------------------------------------------
   function transfer(Data storage self, address to, uint tokens) public returns (bool success) {
       // Owner and minter can move tokens before the tokens are transferable
       require(self.transferable || (self.mintable && (msg.sender == self.owner  || msg.sender == self.minter)));
       require(!self.accountLocked[msg.sender]);
       self.balances[msg.sender] = safeSub(self.balances[msg.sender], tokens);
       self.balances[to] = safeAdd(self.balances[to], tokens);
       emit Transfer(msg.sender, to, tokens);
       return true;
   }
   function approve(Data storage self, address spender, uint tokens) public returns (bool success) {
       require(!self.accountLocked[msg.sender]);
       self.allowed[msg.sender][spender] = tokens;
       emit Approval(msg.sender, spender, tokens);
       return true;
   }
   function transferFrom(Data storage self, address from, address to, uint tokens) public returns (bool success) {
       require(self.transferable);
       require(!self.accountLocked[from]);
       self.balances[from] = safeSub(self.balances[from], tokens);
       self.allowed[from][msg.sender] = safeSub(self.allowed[from][msg.sender], tokens);
       self.balances[to] = safeAdd(self.balances[to], tokens);
       emit Transfer(from, to, tokens);
       return true;
   }
   function approveAndCall(Data storage self, address spender, uint tokens, bytes memory data) public returns (bool success) {
       require(!self.accountLocked[msg.sender]);
       self.allowed[msg.sender][spender] = tokens;
       emit Approval(msg.sender, spender, tokens);
       ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
       return true;
   }

   // ------------------------------------------------------------------------
   // Signed function
   // ------------------------------------------------------------------------
   function signedTransferHash(Data storage /*self*/, address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
       hash = keccak256(abi.encodePacked(signedTransferSig, address(this), tokenOwner, to, tokens, fee, nonce));
   }
   function signedTransferCheck(Data storage self, address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public view returns (BTTSTokenInterface.CheckResult result) {
       if (!self.transferable) return BTTSTokenInterface.CheckResult.NotTransferable;
       bytes32 hash = signedTransferHash(self, tokenOwner, to, tokens, fee, nonce);
       if (tokenOwner == address(0) || tokenOwner != ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig)) return BTTSTokenInterface.CheckResult.SignerMismatch;
       if (self.accountLocked[tokenOwner]) return BTTSTokenInterface.CheckResult.AccountLocked;
       if (self.nextNonce[tokenOwner] != nonce) return BTTSTokenInterface.CheckResult.InvalidNonce;
       uint total = safeAdd(tokens, fee);
       if (self.balances[tokenOwner] < tokens) return BTTSTokenInterface.CheckResult.InsufficientTokens;
       if (self.balances[tokenOwner] < total) return BTTSTokenInterface.CheckResult.InsufficientTokensForFees;
       if (self.balances[to] + tokens < self.balances[to]) return BTTSTokenInterface.CheckResult.OverflowError;
       if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return BTTSTokenInterface.CheckResult.OverflowError;
       return BTTSTokenInterface.CheckResult.Success;
   }
   function signedTransfer(Data storage self, address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success) {
       require(self.transferable);
       bytes32 hash = signedTransferHash(self, tokenOwner, to, tokens, fee, nonce);
       require(tokenOwner != address(0) && tokenOwner == ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig));
       require(!self.accountLocked[tokenOwner]);
       require(self.nextNonce[tokenOwner] == nonce);
       self.nextNonce[tokenOwner] = nonce + 1;
       self.balances[tokenOwner] = safeSub(self.balances[tokenOwner], tokens);
       self.balances[to] = safeAdd(self.balances[to], tokens);
       emit Transfer(tokenOwner, to, tokens);
       self.balances[tokenOwner] = safeSub(self.balances[tokenOwner], fee);
       self.balances[feeAccount] = safeAdd(self.balances[feeAccount], fee);
       emit Transfer(tokenOwner, feeAccount, fee);
       return true;
   }
   function signedApproveHash(Data storage /*self*/, address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
       hash = keccak256(abi.encodePacked(signedApproveSig, address(this), tokenOwner, spender, tokens, fee, nonce));
   }
   function signedApproveCheck(Data storage self, address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public view returns (BTTSTokenInterface.CheckResult result) {
       if (!self.transferable) return BTTSTokenInterface.CheckResult.NotTransferable;
       bytes32 hash = signedApproveHash(self, tokenOwner, spender, tokens, fee, nonce);
       if (tokenOwner == address(0) || tokenOwner != ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig)) return BTTSTokenInterface.CheckResult.SignerMismatch;
       if (self.accountLocked[tokenOwner]) return BTTSTokenInterface.CheckResult.AccountLocked;
       if (self.nextNonce[tokenOwner] != nonce) return BTTSTokenInterface.CheckResult.InvalidNonce;
       if (self.balances[tokenOwner] < fee) return BTTSTokenInterface.CheckResult.InsufficientTokensForFees;
       if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return BTTSTokenInterface.CheckResult.OverflowError;
       return BTTSTokenInterface.CheckResult.Success;
   }
   function signedApprove(Data storage self, address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success) {
       require(self.transferable);
       bytes32 hash = signedApproveHash(self, tokenOwner, spender, tokens, fee, nonce);
       require(tokenOwner != address(0) && tokenOwner == ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig));
       require(!self.accountLocked[tokenOwner]);
       require(self.nextNonce[tokenOwner] == nonce);
       self.nextNonce[tokenOwner] = nonce + 1;
       self.allowed[tokenOwner][spender] = tokens;
       emit Approval(tokenOwner, spender, tokens);
       self.balances[tokenOwner] = safeSub(self.balances[tokenOwner], fee);
       self.balances[feeAccount] = safeAdd(self.balances[feeAccount], fee);
       emit Transfer(tokenOwner, feeAccount, fee);
       return true;
   }
   function signedTransferFromHash(Data storage /*self*/, address spender, address from, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
       hash = keccak256(abi.encodePacked(signedTransferFromSig, address(this), spender, from, to, tokens, fee, nonce));
   }
   function signedTransferFromCheck(Data storage self, address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public view returns (BTTSTokenInterface.CheckResult result) {
       if (!self.transferable) return BTTSTokenInterface.CheckResult.NotTransferable;
       bytes32 hash = signedTransferFromHash(self, spender, from, to, tokens, fee, nonce);
       if (spender == address(0) || spender != ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig)) return BTTSTokenInterface.CheckResult.SignerMismatch;
       if (self.accountLocked[from]) return BTTSTokenInterface.CheckResult.AccountLocked;
       if (self.nextNonce[spender] != nonce) return BTTSTokenInterface.CheckResult.InvalidNonce;
       uint total = safeAdd(tokens, fee);
       if (self.allowed[from][spender] < tokens) return BTTSTokenInterface.CheckResult.InsufficientApprovedTokens;
       if (self.allowed[from][spender] < total) return BTTSTokenInterface.CheckResult.InsufficientApprovedTokensForFees;
       if (self.balances[from] < tokens) return BTTSTokenInterface.CheckResult.InsufficientTokens;
       if (self.balances[from] < total) return BTTSTokenInterface.CheckResult.InsufficientTokensForFees;
       if (self.balances[to] + tokens < self.balances[to]) return BTTSTokenInterface.CheckResult.OverflowError;
       if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return BTTSTokenInterface.CheckResult.OverflowError;
       return BTTSTokenInterface.CheckResult.Success;
   }
   function signedTransferFrom(Data storage self, address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success) {
       require(self.transferable);
       bytes32 hash = signedTransferFromHash(self, spender, from, to, tokens, fee, nonce);
       require(spender != address(0) && spender == ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig));
       require(!self.accountLocked[from]);
       require(self.nextNonce[spender] == nonce);
       self.nextNonce[spender] = nonce + 1;
       self.balances[from] = safeSub(self.balances[from], tokens);
       self.allowed[from][spender] = safeSub(self.allowed[from][spender], tokens);
       self.balances[to] = safeAdd(self.balances[to], tokens);
       emit Transfer(from, to, tokens);
       self.balances[from] = safeSub(self.balances[from], fee);
       self.allowed[from][spender] = safeSub(self.allowed[from][spender], fee);
       self.balances[feeAccount] = safeAdd(self.balances[feeAccount], fee);
       emit Transfer(from, feeAccount, fee);
       return true;
   }
   function signedApproveAndCallHash(Data storage /*self*/, address tokenOwner, address spender, uint tokens, bytes memory data, uint fee, uint nonce) public view returns (bytes32 hash) {
       hash = keccak256(abi.encodePacked(signedApproveAndCallSig, address(this), tokenOwner, spender, tokens, data, fee, nonce));
   }
   function signedApproveAndCallCheck(Data storage self, address tokenOwner, address spender, uint tokens, bytes memory data, uint fee, uint nonce, bytes memory sig, address feeAccount) public view returns (BTTSTokenInterface.CheckResult result) {
       if (!self.transferable) return BTTSTokenInterface.CheckResult.NotTransferable;
       bytes32 hash = signedApproveAndCallHash(self, tokenOwner, spender, tokens, data, fee, nonce);
       if (tokenOwner == address(0) || tokenOwner != ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig)) return BTTSTokenInterface.CheckResult.SignerMismatch;
       if (self.accountLocked[tokenOwner]) return BTTSTokenInterface.CheckResult.AccountLocked;
       if (self.nextNonce[tokenOwner] != nonce) return BTTSTokenInterface.CheckResult.InvalidNonce;
       if (self.balances[tokenOwner] < fee) return BTTSTokenInterface.CheckResult.InsufficientTokensForFees;
       if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return BTTSTokenInterface.CheckResult.OverflowError;
       return BTTSTokenInterface.CheckResult.Success;
   }
   function signedApproveAndCall(Data storage self, address tokenOwner, address spender, uint tokens, bytes memory data, uint fee, uint nonce, bytes memory sig, address feeAccount) public returns (bool success) {
       require(self.transferable);
       bytes32 hash = signedApproveAndCallHash(self, tokenOwner, spender, tokens, data, fee, nonce);
       require(tokenOwner != address(0) && tokenOwner == ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig));
       require(!self.accountLocked[tokenOwner]);
       require(self.nextNonce[tokenOwner] == nonce);
       self.nextNonce[tokenOwner] = nonce + 1;
       self.allowed[tokenOwner][spender] = tokens;
       emit Approval(tokenOwner, spender, tokens);
       self.balances[tokenOwner] = safeSub(self.balances[tokenOwner], fee);
       self.balances[feeAccount] = safeAdd(self.balances[feeAccount], fee);
       emit Transfer(tokenOwner, feeAccount, fee);
       ApproveAndCallFallBack(spender).receiveApproval(tokenOwner, tokens, address(this), data);
       return true;
   }
}


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
    event SetWhiteList(address whiteList);


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    function initRoyaltyToken(address _owner, string calldata _symbol, string calldata _name, uint8 _decimals, uint _initialSupply, bool _mintable, bool _transferable, address _whiteList) external {
        if (_initialSupply > 0 ) {
            require(WhiteListInterface(_whiteList).isInWhiteList(_owner));
        }
        setWhiteList(_whiteList);
        data.init(_owner, _symbol, _name, _decimals, _initialSupply, _mintable, _transferable);

    }


    // ------------------------------------------------------------------------
    // Whitelist
    // ------------------------------------------------------------------------
    function setWhiteList (address _whiteList)  public  {
        // require(msg.sender == data.owner);  AG: 
        whiteList = WhiteListInterface(_whiteList);
        emit SetWhiteList(_whiteList);
    }

    function isInWhiteList(address _address) public view returns (bool) {
        return whiteList.isInWhiteList(_address); 
    }

    function getWhiteList() public returns (address){
        return address(whiteList);
    }


    // ------------------------------------------------------------------------
    // Minting and management
    // ------------------------------------------------------------------------
    function mint(address tokenOwner, uint tokens, bool lockAccount) public override returns (bool success) {
      require(_canReceive(address(0x0),tokenOwner));
       return data.mint(tokenOwner, tokens, lockAccount);
    }

    // ------------------------------------------------------------------------
    // Token functions
    // ------------------------------------------------------------------------

    function transfer(address to, uint tokens) public override returns (bool success) {
       _canTransfer(msg.sender,to, tokens);
       return data.transfer(to, tokens);
    }
    function transferFrom(address from, address to, uint tokens) public override returns (bool success) {
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
        require(isInWhiteList(to), 'Not in whitelist');
        // Set last points for sending to new accounts.
        if (data.balances[to] == 0 && lastEthPoints[to] == 0 && totalDividendPoints > 0) {
          lastEthPoints[to] = totalDividendPoints;
        }
        _updateAccount(to);
        success = true;
    }
    function _canSend(address from, address to) internal returns (bool success) {
        require(from != address(0));
        require(isInWhiteList(from), 'Not in whitelist');
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

   function depositDividends() external payable {
        require(msg.value > 0);
        _depositDividends(msg.value);
    }

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
    ///SS: Is this okay To OVerride?
    
    receive() external override payable {
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
    function withdrawDividendsByAccount (address payable _account) external  {
        require(msg.sender == data.owner);
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
    function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public override returns (bool success) {
        require(_canTransfer(tokenOwner,to, tokens));
        return data.signedTransfer(tokenOwner, to, tokens, fee, nonce, sig, feeAccount);
    }

    function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes memory sig, address feeAccount) public override returns (bool success) {
        require(_canTransfer(from,to, tokens));
        return data.signedTransferFrom(spender, from, to, tokens, fee, nonce, sig, feeAccount);
    }

}
