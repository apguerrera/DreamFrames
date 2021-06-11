pragma solidity ^0.6.12;


//-------------------------------------------------------------------------
// @title IERCST Security Token Standard (EIP 1400)
// @dev See https://github.com/SecurityTokenStandard/EIP-Spec
//-------------------------------------------------------------------------

contract CanSendCodes {
      byte constant TRANSFER_VERIFIED_UNRESTRICTED = 0xA0;                // Transfer Verified - Unrestricted
      byte constant TRANSFER_VERIFIED_ONCHAIN_APPROVAL = 0xA1;            // Transfer Verified - On-Chain approval for restricted token
      byte constant TRANSFER_VERIFIED_OFFCHAIN_APPROVAL = 0xA2;           // Transfer Verified - Off-Chain approval for restricted token
      byte constant TRANSFER_BLOCKED_SENDER_LOCKED_PERIOD = 0xA3;         // Transfer Blocked - Sender lockup period not ended
      byte constant TRANSFER_BLOCKED_SENDER_BALANCE_INSUFFICIENT = 0xA4;  // Transfer Blocked - Sender balance insufficient
      byte constant TRANSFER_BLOCKED_SENDER_NOT_ELIGIBLE = 0xA5;          // Transfer Blocked - Sender not eligible
      byte constant TRANSFER_BLOCKED_RECEIVER_NOT_ELIGIBLE = 0xA6;        // Transfer Blocked - Receiver not eligible
      byte constant TRANSFER_BLOCKED_IDENTITY_RESTRICTION = 0xA7;         // Transfer Blocked - Identity restriction
      byte constant TRANSFER_BLOCKED_TOKEN_RESTRICTION = 0xA8;            // Transfer Blocked - Token restriction
      byte constant TRANSFER_BLOCKED_TOKEN_GRANULARITY = 0xA9;            // Transfer Blocked - Token granularity
}
