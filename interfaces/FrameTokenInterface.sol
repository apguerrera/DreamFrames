pragma solidity ^0.5.4;

// ----------------------------------------------------------------------------
// PriceFeed Interface - _live is true if the rate is valid, false if invalid
// ----------------------------------------------------------------------------
contract FrameTokenInterface {
    function init(address owner, string memory symbol, string memory name, uint8 decimals, uint initialSupply, bool mintable, bool transferable) public;
}
