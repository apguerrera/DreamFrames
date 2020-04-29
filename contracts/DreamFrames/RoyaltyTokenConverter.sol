pragma solidity ^0.5.4;

// ----------------------------------------------------------------------------
// DreamFrames Token Converter
//
// Authors:
// * Adrian Guerrera / Deepyr Pty Ltd
//
// Oct 20 2018
// ----------------------------------------------------------------------------


import "../Shared/SafeMath.sol";
import "../Shared/Operated.sol";
import "../../interfaces/BTTSTokenInterface120.sol";
import "../../interfaces/WhiteListInterface.sol";


contract RoyaltyTokenConverter is Operated {

    using SafeMath for uint256;

    BTTSTokenInterface public frameToken;
    BTTSTokenInterface public royaltyToken;
    bool public isConvertable;

    event FrameTokenUpdated(address operator, address frameToken);
    event RoyaltyTokenUpdated(address operator, address  royaltyToken);
    event SetIsConvertable(address operator, bool isConvertable);
    event ConvertedRoyaltyToken(address account, uint256 amount);


    function initTokenConverter(
        address _frameToken,
        address _royaltyToken,
        bool _isConvertable
    )
        public
    {
        initOperated(msg.sender);
        frameToken = BTTSTokenInterface(_frameToken);
        royaltyToken = BTTSTokenInterface(_royaltyToken);
        isConvertable = _isConvertable;
    }

    // ----------------------------------------------------------------------------
    // Setter functions
    // ----------------------------------------------------------------------------
    
    function setFrameToken(address _contract) public  {
        require(msg.sender == owner);
        require(_contract != address(0));
        frameToken = BTTSTokenInterface(_contract);
        emit FrameTokenUpdated(msg.sender, _contract);
    }
    function setRoyaltyToken(address _contract) public  {
        require(msg.sender == owner);
        require(_contract != address(0));
        royaltyToken = BTTSTokenInterface(_contract);
        emit RoyaltyTokenUpdated(msg.sender, _contract);
    }
    function setConvertable(bool _isConvertable) public  {
        require(msg.sender == owner);
        isConvertable = _isConvertable;
        emit SetIsConvertable(msg.sender, _isConvertable);
    }


    // ----------------------------------------------------------------------------
    // Royalty Token Conversions
    // ----------------------------------------------------------------------------

    function canConvert(address _account,  uint256 _amount)
        external view returns (bool success)
    {
        return _canConvert(_account, _amount);
    }

    function convertRoyaltyToken( address _account, uint256 _amount)
        public returns (bool success)
    {
        require( isConvertable );
        require(frameToken.transferFrom(_account, address(0), _amount));
        require(royaltyToken.mint(_account, _amount, false));
        emit ConvertedRoyaltyToken(_account, _amount);
        success = true;
    }

    function receiveApproval(address _from, uint256 _amount, address _token, bytes memory data)
        public
    {
        require(msg.sender == address(frameToken) && _token == address(frameToken));
        require(convertRoyaltyToken(_from, _amount));
    }


    // ----------------------------------------------------------------------------
    // Internals
    // ----------------------------------------------------------------------------

    function _canConvert(address _account, uint256 _amount )
        internal view returns (bool success)
    {
        // Check inputs
        if (  _amount == 0  ||  _account == address(0)) {
            return false;
        }
        // Check token balances
        if ( frameToken.balanceOf(_account) < _amount || frameToken.accountLocked(_account) ) {
            return false;
        }
        // Check flags
        if ( !isConvertable || !frameToken.transferable() || !royaltyToken.mintable() ) {
            return false;
        }
        // Check whitelist
        WhiteListInterface whitelist = WhiteListInterface(address(royaltyToken));
        if ( whitelist.isInWhiteList(_account) ) {
            return true;
        }
        return false;
    }

}

