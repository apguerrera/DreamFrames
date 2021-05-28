pragma solidity ^0.6.12;

// ----------------------------------------------------------------------------
// PriceFeed Interface - _live is true if the rate is valid, false if invalid
// ----------------------------------------------------------------------------
interface PriceFeedInterface {
    function getRate() external view returns (uint _rate, bool _live);
}
