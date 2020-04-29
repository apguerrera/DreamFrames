pragma solidity ^0.5.4;

// ----------------------------------------------------------------------------
// BokkyPooBah's MakerDAO's "pip" PriceFeed Simulator for testing
//
// Used to simulate the MakerDAO ETH/USD pricefeed on the Ethereum mainnet at
//   https://etherscan.io/address/0x729D19f657BD0614b4985Cf1D82531c67569197B
//
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------

import "../Shared/Owned.sol";


// ----------------------------------------------------------------------------
// Pricefeed with interface compatible with MakerDAO's "pip" PriceFeed
// ----------------------------------------------------------------------------
contract MakerDAOETHUSDPriceFeedSimulator is Owned {
    uint public value;
    bool public hasValue;

    event SetValue(uint oldValue, bool oldHasValue, uint newValue, bool newHasValue);

    constructor(uint _value, bool _hasValue) public {
        initOwned(msg.sender);
        value = _value;
        hasValue = _hasValue;
        emit SetValue(0, false, value, hasValue);
    }
    function setValue(uint _value, bool _hasValue) public  {
        require(msg.sender == owner);
        emit SetValue(value, hasValue, _value, _hasValue);
        value = _value;
        hasValue = _hasValue;
    }
    function peek() public view returns (bytes32 _value, bool _hasValue) {
        _value = bytes32(value);
        _hasValue = hasValue;
    }
}
