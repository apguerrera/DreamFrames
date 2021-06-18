pragma solidity ^0.6.12;

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

// AG: Tokens need to be able to be claimed only if a user is on the whitelist
// AG: Make batchable
// AG: Add updateList call to be batched with merkle data

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


    /// @notice Batch call to convert to royalty tokens
    /// @param revertOnFail if set to true, reverts in the first case of unsuccessul conversion
    function batchConvertRoyaltyToken(address[] calldata _accounts, uint256[] calldata _amounts, bool revertOnFail)
        public returns (bool[] memory successes)
    {   
        require(msg.sender == owner);
        require(_accounts.length == _amounts.length, "RoyaltyTokenConverter: Number of Accounts and Amounts different");
        successes = new bool[](_accounts.length);
        for (uint i = 0; i < _accounts.length; i++){
            bool success;
            if(_accounts[i]!=address(0) && WhiteListInterface(address(royaltyToken)).isInWhiteList(_accounts[i])){
                success = _convertRoyaltyToken(_accounts[i], _amounts[i]);
                require(success || !revertOnFail, "RoyaltyTokenConverter: Batch conversion failed");
            }
            successes[i] = success;
        }

    }
    
    /// @dev should only be msg.sender
    function convertRoyaltyToken( uint256 _amount)
        public returns (bool success)

    {   
        success = _convertRoyaltyToken(msg.sender,_amount);
        return success;
    }

    function _convertRoyaltyToken( address _account, uint256 _amount)
        internal returns (bool success)
    {
        require( isConvertable );
        require(_canConvert(_account,_amount));
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
        if ( WhiteListInterface(address(royaltyToken)).isInWhiteList(_account) ) {
            return true;
        }
        return false;
    }

}

