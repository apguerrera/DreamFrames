pragma solidity ^0.5.4;

// ----------------------------------------------------------------------------
// Bonus List interface
// ----------------------------------------------------------------------------
contract WhiteListInterface {
    function isInWhiteList(address account) external view returns (bool);
    function add(address[] calldata accounts) external ;
    function remove(address[] calldata accounts) external ;
    function initWhiteList(address owner) external ;
    function transferOwnershipImmediately(address _newOwner) external;


}
