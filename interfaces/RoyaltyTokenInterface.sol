pragma solidity ^0.5.4;

// ----------------------------------------------------------------------------
// PriceFeed Interface - _live is true if the rate is valid, false if invalid
// ----------------------------------------------------------------------------
contract RoyaltyTokenInterface {
    function initRoyaltyToken(address _owner, string memory _symbol, string memory _name, uint8 _decimals, uint _initialSupply, bool _mintable, bool _transferable, address _whiteList) public;
    function getWhiteList() public returns (address);
    function isInWhiteList(address account) public view returns (bool);

}
