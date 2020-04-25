pragma solidity ^0.5.4;

// ----------------------------------------------------------------------------
// Bonus List interface
// ----------------------------------------------------------------------------
contract WhiteListInterface {
    function isInWhiteList(address account) public view returns (bool);
    function add(address[] memory accounts) public ;
}
