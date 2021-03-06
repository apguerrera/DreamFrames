pragma solidity ^0.6.12;

// ----------------------------------------------------------------------------
// PriceFeed Interface - _live is true if the rate is valid, false if invalid
// ----------------------------------------------------------------------------
interface RoyaltyTokenInterface {
    function initRoyaltyToken(address _owner, string memory _symbol, string memory _name, uint8 _decimals, uint _initialSupply, bool _mintable, bool _transferable, address _whiteList) external;
    function getWhiteList() external returns (address);
    function isInWhiteList(address account) external view returns (bool);

}
