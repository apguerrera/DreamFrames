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


contract FrameTokenConverter is Operated {

    using SafeMath for uint256;

    address public frameToken;
    address public royaltyToken;
    address public collectableToken;

    event FrameTokenUpdated(address operator, address frameToken);
    event RoyaltyTokenUpdated(address operator, address  royaltyToken);
    event CollectableTokenUpdated(address operator, address collectableToken);

    event ConvertedRoyaltyToken(address account, uint256 amount);
    event ClaimedCollectableToken(address account, uint256 tokenId);


    constructor() public {
    }


    // ----------------------------------------------------------------------------
    // Setter functions
    // ----------------------------------------------------------------------------
    
    function setFrameToken(address payable _contract) public onlyOwner {
        require(_contract != address(0));
        emit FrameTokenUpdated(msg.sender, _contract);
        frameToken = _contract;
    }
    function setRoyaltyToken(address payable _contract) public onlyOwner {
        require(_contract != address(0));
        emit RoyaltyTokenUpdated(msg.sender, _contract);
        royaltyToken = _contract;
    }
    function setCollectableToken(address payable _contract) public onlyOwner {
        require(_contract != address(0));
        emit CollectableTokenUpdated(msg.sender, _contract);
        collectableToken = _contract;
    }

    // ----------------------------------------------------------------------------
    // Royalty Token Conversions
    // ----------------------------------------------------------------------------

    function canConvert(address _account,  uint256 _amount)
        external
        view
        returns (bool success)
    {
        return _canConvert(_account, _amount);
    }


    function convertRoyaltyToken(
        address _account,
        uint256 _amount

    )
        external
        returns (bool success)
    {
        require(_canConvert(_account, _amount));
        // IERC777 fromToken = IERC777(_oldToken);
        // IBaseToken toToken = IBaseToken(_newToken);
        // fromToken.operatorBurn(_account, _amount, _holderData, _operatorData);
        // toToken.operatorMint(_account, _amount.mul(_multiple), _holderData, _operatorData);
        emit ConvertedRoyaltyToken(_account, _amount);

        success = true;

    }

    // ----------------------------------------------------------------------------
    // Claim Frame Collectable
    // ----------------------------------------------------------------------------

    function canClaim(address _account,  uint256 _tokenId)
        external
        view
        returns (bool success)
    {
        return _canConvert(_account, _tokenId);
    }

    function claimCollectableToken(
        address _account,
        uint256 _tokenId
    )
        external
        returns (bool success)
    {
        require(_canClaim(_account, _tokenId));
        emit ClaimedCollectableToken(_account, _tokenId);
        success = true;

    }



    // ----------------------------------------------------------------------------
    // Internals
    // ----------------------------------------------------------------------------

    function _canConvert(address _account, uint256 _amount )
        internal
        pure
        returns (bool success)
    {
        require(_amount != 0);
        // replace with amount check logic
        require(_account != address(0)); 

        // replace with amount check logic
        // check can send, check can receive
        // check convert logic
        // WhiteListInterface whitelist = WhiteListInterface(_whitelist);
        // whitelist.isInWhiteList(_partition, _account);
        success = true;
    }


    function _canClaim(address _account, uint256 _tokenId )
        internal
        pure
        returns (bool success)
    {
        require(_tokenId != 0);
        // replace with amount check logic
        require(_account != address(0)); 

        // replace with amount check logic
        // check can send, check can receive
        // check convert logic
        // WhiteListInterface whitelist = WhiteListInterface(_whitelist);
        // whitelist.isInWhiteList(_partition, _account);
        success = true;
    }



}

