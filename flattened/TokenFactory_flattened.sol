pragma solidity ^0.6.12;



// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address payable public owner;
    address public newOwner;
    bool private initialised;

     event OwnershipTransferred(address indexed from, address indexed to);

    function initOwned(address  _owner) internal {
        require(!initialised);
        owner = address(uint160(_owner));
        initialised = true;
    }
    function transferOwnership(address _newOwner) public {
        require(msg.sender == owner);
        newOwner = _newOwner;
    }
    function acceptOwnership()  public  {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = address(uint160(newOwner));
        newOwner = address(0);
    }
    function transferOwnershipImmediately(address _newOwner) public {
        require(msg.sender == owner);
        emit OwnershipTransferred(owner, _newOwner);
        owner = address(uint160(_newOwner));
    }
}

// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
        require(b > 0);
        c = a / b;
    }
    function max(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a >= b ? a : b;
    }
    function min(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a <= b ? a : b;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256 c) {
        require(b != 0);
        c =  a % b;
    }
}

// ----------------------------------------------------------------------------
// CloneFactory.sol
// From
// https://github.com/optionality/clone-factory/blob/32782f82dfc5a00d103a7e61a17a5dedbd1e8e9d/contracts/CloneFactory.sol
// ----------------------------------------------------------------------------

/*
The MIT License (MIT)
Copyright (c) 2018 Murray Software, LLC.
Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
//solhint-disable max-line-length
//solhint-disable no-inline-assembly

contract CloneFactory {

  function createClone(address target) internal returns (address result) {
    bytes20 targetBytes = bytes20(target);
    assembly {
      let clone := mload(0x40)
      mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
      mstore(add(clone, 0x14), targetBytes)
      mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
      result := create(0, clone, 0x37)
    }
  }

  function isClone(address target, address query) internal view returns (bool result) {
    bytes20 targetBytes = bytes20(target);
    assembly {
      let clone := mload(0x40)
      mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
      mstore(add(clone, 0xa), targetBytes)
      mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

      let other := add(clone, 0x40)
      extcodecopy(query, other, 0, 0x2d)
      result := and(
        eq(mload(clone), mload(other)),
        eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
      )
    }
  }
}

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

  function totalSupply() public view returns (uint);
  function balanceOf(address tokenOwner) public view returns (uint balance);
  function allowance(address tokenOwner, address spender) public view returns (uint remaining);
  function transfer(address to, uint tokens) public returns (bool success);
  function approve(address spender, uint tokens) public returns (bool success);
  function transferFrom(address from, address to, uint tokens) public returns (bool success);
}

// ----------------------------------------------------------------------------
// PriceFeed Interface - _live is true if the rate is valid, false if invalid
// ----------------------------------------------------------------------------
contract RoyaltyTokenInterface {
    function initRoyaltyToken(address _owner, string memory _symbol, string memory _name, uint8 _decimals, uint _initialSupply, bool _mintable, bool _transferable, address _whiteList) public;
    function getWhiteList() public returns (address);
    function isInWhiteList(address account) public view returns (bool);

}

// ----------------------------------------------------------------------------
// PriceFeed Interface - _live is true if the rate is valid, false if invalid
// ----------------------------------------------------------------------------
contract FrameTokenInterface {
    function init(address owner, string memory symbol, string memory name, uint8 decimals, uint initialSupply, bool mintable, bool transferable) public;
}

// ----------------------------------------------------------------------------
// Bonus List interface
// ----------------------------------------------------------------------------
contract WhiteListInterface {
    function isInWhiteList(address account) external view returns (bool);
    function add(address[] calldata accounts) external ;
    function remove(address[] calldata accounts) external ;
    function initWhiteList(address owner) external ;
    function transferOwnershipImmediately(address _newOwner) external;


}


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
    address public whiteListTemplate;

    address public newAddress;
    uint256 public minimumFee = 0;
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
        uint8 _decimals,
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
        FrameTokenInterface(frameToken).init(_owner, _symbol, _name, _decimals, _initialSupply, _mintable, _transferable);
        emit FrameTokenDeployed(msg.sender, address(frameToken), frameTokenTemplate, msg.value);
        if (msg.value > 0) {
            owner.transfer(msg.value);
        }
    }

    function deployRoyaltyToken(
        address _owner,
        string memory _symbol,
        string memory _name,
        uint8 _decimals,
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
        RoyaltyTokenInterface(royaltyToken).initRoyaltyToken(_owner, _symbol, _name, _decimals, _initialSupply, _mintable, _transferable, whiteList);

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
