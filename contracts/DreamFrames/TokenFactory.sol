pragma solidity ^0.6.12;


import "../Shared/Owned.sol";
import "../Shared/SafeMath.sol";
import "../Shared/CloneFactory.sol";
import "../../interfaces/ERC20Interface.sol";
import "../../interfaces/RoyaltyTokenInterface.sol";
import "../../interfaces/FrameTokenInterface.sol";
import "../../interfaces/WhiteListInterface.sol";


// ----------------------------------------------------------------------------
// Dream Frames Factory
//
// Authors:
// * Adrian Guerrera / Deepyr Pty Ltd / Dream Frames
//
// Modified from BokkyPooBah's Fixed Supply Token 👊 Factory
//
// ----------------------------------------------------------------------------

// AG: Upgrade factory to do multiple templates
// AG: Add template ID accounting

contract TokenFactory is  Owned, CloneFactory {
    using SafeMath for uint;

    address public frameTokenTemplate;
    address public royaltyTokenTemplate;
    address public whiteListTemplate;

    address public newAddress;
    uint256 public minimumFee = 0;
    uint8 public decimals = 18;
    mapping(address => bool) public isChild;
    address[] public children;

    event FrameTokenDeployed(address indexed owner, address indexed addr, address frameToken, uint256 fee);
    event RoyaltyTokenDeployed(address indexed owner, address indexed addr, address royaltyToken, uint256 fee);
    event WhiteListDeployed(address indexed operator, address indexed addr, address whiteList, address owner);

    event FactoryDeprecated(address _newAddress);
    event MinimumFeeUpdated(uint oldFee, uint newFee);


    constructor(
        address _frameTokenTemplate,
        address _royaltyTokenTemplate,
        address _whiteListTemplate,
        uint256 _minimumFee
    )
        public
    {
        initOwned(msg.sender);
        frameTokenTemplate = _frameTokenTemplate;
        royaltyTokenTemplate = _royaltyTokenTemplate;
        whiteListTemplate = _whiteListTemplate;
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


    // ----------------------------------------------------------------------------
    // Token Deployments
    // ----------------------------------------------------------------------------

    function deployFrameToken(
        address _owner,
        string memory _symbol,
        string memory _name,
        uint _initialSupply,
        bool _mintable,
        bool _transferable
    )
        public payable returns (address frameToken)
    {
        require(msg.value >= minimumFee);
        frameToken = createClone(frameTokenTemplate);
        isChild[address(frameToken)] = true;
        children.push(address(frameToken));
        FrameTokenInterface(frameToken).init(_owner, _symbol, _name, decimals, _initialSupply, _mintable, _transferable);
        emit FrameTokenDeployed(msg.sender, address(frameToken), frameTokenTemplate, msg.value);
        if (msg.value > 0) {
            owner.transfer(msg.value);
        }
    }

    function deployRoyaltyToken(
        address _owner,
        string memory _symbol,
        string memory _name,
        uint _initialSupply,
        bool _mintable,
        bool _transferable
    )
        public  payable returns (address royaltyToken)
    {
        require(msg.value >= minimumFee);
        royaltyToken = createClone(royaltyTokenTemplate);
        isChild[address(royaltyToken)] = true;
        children.push(address(royaltyToken));
        address[] memory whiteListed = new address[](1);
        if (_initialSupply > 0 ) {
            whiteListed[0] = _owner;
        }
        address whiteList = deployWhiteList(_owner, whiteListed);
        RoyaltyTokenInterface(royaltyToken).initRoyaltyToken(_owner, _symbol, _name, decimals, _initialSupply, _mintable, _transferable, whiteList);

        emit RoyaltyTokenDeployed(msg.sender, address(royaltyToken), royaltyTokenTemplate, msg.value);
        if (msg.value > 0) {
            owner.transfer(msg.value);
        }
    }

    function deployWhiteList(
        address owner,
        address[] memory whiteListed
    )
        public payable returns (address whiteList)
    {
        whiteList = createClone(whiteListTemplate);
        WhiteListInterface(whiteList).initWhiteList(address(this));
        WhiteListInterface(whiteList).add(whiteListed);
        WhiteListInterface(whiteList).transferOwnershipImmediately(owner);
        isChild[address(whiteList)] = true;
        children.push(address(whiteList));
        emit WhiteListDeployed(msg.sender, address(whiteList), whiteListTemplate, owner);
    }


    // ----------------------------------------------------------------------------
    // Footer Functions
    // ----------------------------------------------------------------------------

    function transferAnyERC20Token(
        address tokenAddress,
        uint256 tokens
    )
        public  returns (bool success)
    {
        require(msg.sender == owner);
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
    receive() external payable {
        revert();
    }
}