pragma solidity ^0.5.4;

// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address payable public owner;
    address public newOwner;
    bool private initialised;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function initOwned(address  _owner) internal {
        require(!initialised);
        owner = address(uint160(_owner));
        initialised = true;
    }
    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership()  public  {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = address(uint160(newOwner));
        newOwner = address(0);
    }
    function transferOwnershipImmediately(address _newOwner) public onlyOwner {
        emit OwnershipTransferred(owner, _newOwner);
        owner = address(uint160(_newOwner));
    }
}
