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
import "../../interfaces/IERC721.sol";
import "../library/Counters.sol";

// AG: Tokens need to be swapped for NFTS
// AG: Think about when tokens can be claimed
// AG: Add timing conditions for claiming

contract FrameRush is Operated {

    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;


    BTTSTokenInterface public frameToken;
    IERC721 public collectableToken;
    bool public isClaimable;
    uint256 public lockTime;

    /// @dev this is the number of tokens per collectable
    uint256 public frameRate;

    event FrameTokenUpdated(address operator, address frameToken);
    event CollectableTokenUpdated(address operator, address collectableToken);
    event SetIsClaimable(address operator, bool isClaimable);
    event SetFrameRate(address operator, uint256 frameRate);
    event LockTimeUpdated(address operator, uint256 lockTime);
    event ConvertedRoyaltyToken(address account, uint256 amount);
    event ClaimedCollectableToken(address account, uint256 tokenId);

    function initFrameRush(
        address _frameToken,
        address _collectableToken,
        bool _isClaimable,
        uint256 _lockPeriod
    )
        public
    {
        initOperated(msg.sender);
        frameToken = BTTSTokenInterface(_frameToken);
        collectableToken = IERC721(_collectableToken);
        isClaimable = _isClaimable;
        lockTime = block.timestamp + _lockPeriod;
        frameRate = 25 * 1e18;
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
        collectableToken = IERC721(_contract);
        emit CollectableTokenUpdated(msg.sender, _contract);
    }
    function setClaimable(bool _isClaimable) public  {
        require(msg.sender == owner);
        isClaimable = _isClaimable;
        emit SetIsClaimable(msg.sender, _isClaimable);
    }
    function setFrameRate(uint256 _frameRate) public {
        require(msg.sender == owner);
        frameRate = _frameRate;
        emit SetFrameRate(msg.sender, _frameRate);
    }
    function setLockTime(uint256 _lockPeriod) public  {
        require(msg.sender == owner);
        lockTime = block.timestamp + _lockPeriod;
        emit LockTimeUpdated(msg.sender, lockTime);
    }

    // ----------------------------------------------------------------------------
    // Claim Frame Collectable
    // ----------------------------------------------------------------------------

    function canClaim(address _account,  uint256 _tokenId)
        external view returns (bool success)
    {
        return _canClaim(_account, _tokenId);
    }

    function claimCollectableToken(address _account, uint256 _tokenId) public returns (bool success){
        
        require(isTokenIdAvailable(_tokenId), "CollectableToken: tokenId already exists");
        
        success = _claimCollectableToken(_account, _tokenId);
    }
    // ----------------------------------------------------------------------------
    // Internals
    // ----------------------------------------------------------------------------
    
    function _claimCollectableToken(address _account, uint256 _tokenId )
        internal returns (bool success)
    {   
        require( isClaimable );
        require(_canClaim(_account, _tokenId), "Frame Rush: Token cannot be claimed");
        require(frameToken.transferFrom(_account, address(0), frameRate));
        collectableToken.mint(_account, _tokenId);
        emit ClaimedCollectableToken(_account, _tokenId);
        success = true;
    }

  

    function _canClaim(address _account, uint256 _tokenId )
        internal view returns (bool success)
    {
        // Check inputs
        if (  _account == address(0) || _tokenId == 0) {
            return false;
        }
        // Check token balances
        if ( frameToken.balanceOf(_account) < frameRate || frameToken.accountLocked(_account) ) {
            return false;
        }
        // Check flags
        if ( !isClaimable || !frameToken.transferable() /*|| !collectableToken.mintable()*/ ) {
            return false;
        }
        //Check NFT
        if ( block.timestamp < lockTime ){
            return false;
        }

        success = true;
    }

    function isTokenIdAvailable(uint256 _tokenId) public view returns  (bool isAvailable){
        isAvailable = !collectableToken.exists(_tokenId);
    }

    /* function getClosestTokenIdAvailable(uint256 _tokenId) public view returns (uint256 tokenId){
        tokenId = collectableToken.getClosestTokenIdAvailable(_tokenId);
    } */

}

