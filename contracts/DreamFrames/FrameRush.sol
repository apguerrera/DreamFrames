pragma solidity ^0.6.12;

// ----------------------------------------------------------------------------
// DreamFrames FrameRush 
//
// Claim ERC721 memorabilia by burning Frame Tokens  
//
// Authors:
// * Adrian Guerrera / Deepyr Pty Ltd
//
// Oct 20 2018
// ----------------------------------------------------------------------------


import "../Shared/SafeMath.sol";
import "../Shared/Operated.sol";
import "../../interfaces/BTTSTokenInterface120.sol";

// AG: Tokens need to be swapped for NFTS
// AG: Think about when tokens can be claimed
// AG: Add timing conditions for claiming

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
        require( isClaimable );
        uint256 amount = 25;
        require(frameToken.transferFrom(_account, address(0), amount));
        // require(collectableToken.mint(_account, _tokenId));  // Not supported yet
        emit ClaimedCollectableToken(_account, _tokenId);
        success = true;

    }

    // ----------------------------------------------------------------------------
    // Internals
    // ----------------------------------------------------------------------------

    function _canClaim(address _account, uint256 _tokenId )
        internal view returns (bool success)
    {
        require(_tokenId != 0);
        require(_account != address(0)); 
        uint256 amount = 25;

        // Check inputs
        if (  _account == address(0)) {
            return false;
        }
        // Check token balances
        if ( frameToken.balanceOf(_account) < amount || frameToken.accountLocked(_account) ) {
            return false;
        }
        // Check flags
        if ( !isClaimable || !frameToken.transferable() /*|| !collectableToken.mintable()*/ ) {
            return false;
        }


        success = true;
    }

}

