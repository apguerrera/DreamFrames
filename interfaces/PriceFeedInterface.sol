pragma solidity ^0.6.12;

// ----------------------------------------------------------------------------
// PriceFeed Interface - _live is true if the rate is valid, false if invalid
// ----------------------------------------------------------------------------
interface PriceFeedInterface {
    function getRate() public view returns (uint _rate, bool _live);
}
