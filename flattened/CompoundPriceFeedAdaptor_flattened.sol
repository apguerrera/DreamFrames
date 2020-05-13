pragma solidity ^0.5.4;

// ----------------------------------------------------------------------------
// Adaptor to convert Compound's price feed into BokkyPooBah's Pricefeed
//
// Used to convert Compound Dai/ETH pricefeed on the Ethereum mainnet at
// https://etherscan.io/address/0xddc46a3b076aec7ab3fc37420a8edd2959764ec4#readContract// to be a slightly more useable form
//
// Deployed to: 
//
// Author Adrian Guerrera
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// PriceFeed Interface - _live is true if the rate is valid, false if invalid
// ----------------------------------------------------------------------------
contract PriceFeedInterface {
    function getRate() public view returns (uint _rate, bool _live);
}


contract CompoundPriceFeedInterface {
    function getUnderlyingPrice(address _addr) external view returns (uint256 _value);
    function cDaiAddress() external view returns (address _addr);
}


// ----------------------------------------------------------------------------
// Pricefeed with interface compatible with Compound's PriceFeed
// ----------------------------------------------------------------------------
contract CompoundPriceFeedAdaptor is PriceFeedInterface {
    CompoundPriceFeedInterface public compoundPriceFeed;
    address public cDaiAddress;

    constructor(address _compoundPriceFeed) public {
        compoundPriceFeed = CompoundPriceFeedInterface(_compoundPriceFeed);
        cDaiAddress = compoundPriceFeed.cDaiAddress();
    }

    function getRate() public view returns (uint256 _rate, bool _live) {
        /// @dev: Returns Dai/ETH ie. 1 Dai = value in wei (10 ** 18)
        uint256 value = compoundPriceFeed.getUnderlyingPrice(cDaiAddress);
        if (value > 0 ) {
            _live = true;
            /// @dev: Convert to ETH/Dai 
            _rate = 10**36 / value;
        }
    }
}
