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


contract FrameRush is Operated {

    using SafeMath for uint256;

    BTTSTokenInterface public frameToken;
    address public collectableToken;
    bool public isClaimable;

    event FrameTokenUpdated(address operator, address frameToken);
    event CollectableTokenUpdated(address operator, address collectableToken);
    event SetIsClaimable(address operator, bool isClaimable);

    event ConvertedRoyaltyToken(address account, uint256 amount);
    event ClaimedCollectableToken(address account, uint256 tokenId);


    function initFrameRush(
        address _frameToken,
        address _collectableToken,
        bool _isClaimable
    )
        public
    {
        initOperated(msg.sender);
        frameToken = BTTSTokenInterface(_frameToken);
        collectableToken = _collectableToken;
        isClaimable = _isClaimable;
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
    function setCollectableToken(address _contract) public  {
        require(msg.sender == owner);
        require(_contract != address(0));
        collectableToken = _contract;
        emit CollectableTokenUpdated(msg.sender, _contract);
    }
    function setClaimable(bool _isClaimable) public  {
        require(msg.sender == owner);
        isClaimable = _isClaimable;
        emit SetIsClaimable(msg.sender, _isClaimable);
    }


    // ----------------------------------------------------------------------------
    // Claim Frame Collectable
    // ----------------------------------------------------------------------------

    function canClaim(address _account,  uint256 _tokenId)
        external view returns (bool success)
    {
        return _canClaim(_account, _tokenId);
    }

    function claimCollectableToken(address _account, uint256 _tokenId )
        external returns (bool success)
    {
        require(_canClaim(_account, _tokenId));
        emit ClaimedCollectableToken(_account, _tokenId);
        success = true;
    }

    // ----------------------------------------------------------------------------
    // Internals
    // ----------------------------------------------------------------------------

    function _canClaim(address _account, uint256 _tokenId )
        internal pure returns (bool success)
    {
        require(_tokenId != 0);
        require(_account != address(0)); 

        // AG: replace with amount check logic
        // check can send, check can receive
        // check convert logic
        success = true;
    }

}

