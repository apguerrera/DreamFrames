pragma solidity ^0.5.4;


import "../Shared/Owned.sol";
import "../Shared/SafeMath.sol";
import "../Shared/CloneFactory.sol";
import "../../interfaces/ERC20Interface.sol";
// import "../../interfaces/IDreamFrameToken.sol";


// ----------------------------------------------------------------------------
// Dream Frames Factory
//
// Authors:
// * Adrian Guerrera / Deepyr Pty Ltd / Dream Frames
//
// Modified from BokkyPooBah's Fixed Supply Token 👊 Factory
//
// ----------------------------------------------------------------------------

contract TokenFactory is  Owned, CloneFactory {
    using SafeMath for uint;

    address public frameTokenTemplate;
    address public royaltyTokenTemplate;

    address public newAddress;
    uint256 public minimumFee = 0;
    mapping(address => bool) public isChild;
    address[] public children;

    event FrameTokenDeployed(address indexed owner, address indexed addr, address frameToken, uint256 fee);
    event RoyaltyTokenDeployed(address indexed owner, address indexed addr, address royaltyToken, uint256 fee);

    event FactoryDeprecated(address _newAddress);
    event MinimumFeeUpdated(uint oldFee, uint newFee);


    constructor(address _frameTokenTemplate, address _royaltyTokenTemplate, uint256 _minimumFee) public  {
        initOwned(msg.sender);
        frameTokenTemplate = _frameTokenTemplate;
        royaltyTokenTemplate = _royaltyTokenTemplate;
        minimumFee = _minimumFee;
    }

    function numberOfChildren() public view returns (uint) {
        return children.length;
    }
    function deprecateFactory(address _newAddress) public  {
        require(msg.sender == owner);
        require(newAddress == address(0));
        emit FactoryDeprecated(_newAddress);
        newAddress = _newAddress;
    }
    function setMinimumFee(uint256 _minimumFee) public  {
        require(msg.sender == owner);
        emit MinimumFeeUpdated(minimumFee, _minimumFee);
        minimumFee = _minimumFee;
    }
    function deployFrameTokenContract() public payable returns (address frameToken)  {
        require(msg.value >= minimumFee);
        frameToken = createClone(frameTokenTemplate);
        isChild[address(frameToken)] = true;
        children.push(address(frameToken));
        emit FrameTokenDeployed(msg.sender, address(frameToken), frameTokenTemplate, msg.value);
        if (msg.value > 0) {
            owner.transfer(msg.value);
        }
    }

    function deployRoyaltyTokenContract() public payable  returns (address royaltyToken)  {
        require(msg.value >= minimumFee);
        royaltyToken = createClone(royaltyTokenTemplate);
        isChild[address(royaltyToken)] = true;
        children.push(address(royaltyToken));
        emit RoyaltyTokenDeployed(msg.sender, address(royaltyToken), royaltyTokenTemplate, msg.value);
        if (msg.value > 0) {
            owner.transfer(msg.value);
        }
    }
    // function deployWhiteList() public payable  returns (address whiteList)  {
    //     require(msg.value >= minimumFee);
    //     whiteList = createClone(whiteListTemplate);
    //     isChild[address(whiteList)] = true;
    //     children.push(address(whiteList));
    //     emit WhiteListDeployed(msg.sender, address(whiteList), whiteListTemplate, msg.value);
    //     if (msg.value > 0) {
    //         owner.transfer(msg.value);
    //     }
    // }
    // footer functions
    function transferAnyERC20Token(address tokenAddress, uint256 tokens) public  returns (bool success) {
        require(msg.sender == owner);
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
    function () external payable {
        revert();
    }
}