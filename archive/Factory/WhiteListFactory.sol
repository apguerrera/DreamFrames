pragma solidity ^0.6.12;

// ----------------------------------------------------------------------------
// DreamFrames WhiteList Factory
//
// Deployed to:
//
// Enjoy.
//
// (c) Adrian Guerrera / Deepyr Pty Ltd for Dream Frames 2019. The MIT Licence.
// ----------------------------------------------------------------------------


import "../RoyaltyToken/WhiteList.sol";
import "../Shared/ERC20Interface.sol";


// ----------------------------------------------------------------------------
// HouWhiteListse Factory
// ----------------------------------------------------------------------------
contract WhiteListFactory is Operated {

    mapping(address => bool) _verify;
    WhiteList[] public deployedWhiteLists;

    event WhiteListDeployed(address indexed whitelist, address indexed deployer);

    constructor() public {
        super.initOperated(msg.sender);
    }

    function deployWhiteList (address _owner) public onlyOperator returns (WhiteList whitelist) {
        whitelist = new WhiteList();
        whitelist.transferOwnershipImmediately(_owner);
        _verify[address(whitelist)] = true;
        deployedWhiteLists.push(whitelist);        
        emit WhiteListDeployed(address(whitelist), msg.sender);
    }

    function verify(address addr) public view returns (bool valid) {
        valid = _verify[addr];
    }

    function numberOfDeployedWhiteLists() public view returns (uint) {
        return deployedWhiteLists.length;
    }

    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }

    receive() external payable {
        revert();
    }

}
