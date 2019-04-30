pragma solidity ^0.5.4;

// ----------------------------------------------------------------------------
// Bonus List interface
// ----------------------------------------------------------------------------
contract BonusListInterface {
    function isInBonusList(address account) public view returns (bool);
}
