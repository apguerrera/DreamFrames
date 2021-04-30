pragma solidity ^0.6.12;

// ----------------------------------------------------------------------------
// Adaptor to convert MakerDAO's "pip" price feed into BokkyPooBah's Pricefeed
//
// Used to convert MakerDAO ETH/USD pricefeed on the Ethereum mainnet at
//   https://etherscan.io/address/0x729D19f657BD0614b4985Cf1D82531c67569197B
// to be a slightly more useable form
//
// Deployed to: 0x12bc52A5a9cF8c1FfBAA2eAA82b75B3E79DfE292
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------

import "../../interfaces/PriceFeedInterface.sol";


// ----------------------------------------------------------------------------
// See https://github.com/bokkypoobah/MakerDAOSaiContractAudit/tree/master/audit#pip-and-pep-price-feeds
// ----------------------------------------------------------------------------
interface MakerDAOPriceFeedInterface {
    function peek() external view returns (bytes32 _value, bool _hasValue);
}


// ----------------------------------------------------------------------------
// Pricefeed with interface compatible with MakerDAO's "pip" PriceFeed
// ----------------------------------------------------------------------------
contract MakerDAOPriceFeedAdaptor is PriceFeedInterface {
    MakerDAOPriceFeedInterface public makerDAOPriceFeed;

    constructor(address _makerDAOPriceFeed) public {
        makerDAOPriceFeed = MakerDAOPriceFeedInterface(_makerDAOPriceFeed);
    }
    function getRate() public override view returns (uint _rate, bool _live) {
        bytes32 value;
        (value, _live) = makerDAOPriceFeed.peek();
        _rate = uint(value);
    }
}
