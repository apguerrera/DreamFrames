pragma solidity ^0.6.12;

import "../Shared/Operated.sol";
import "../DreamFramesToken/DreamFramesToken.sol";


// ----------------------------------------------------------------------------
// Based on BokkyPooBah's Fixed Supply Token 👊 Factory
//
// Notes:
//   * The `newContractAddress` deprecation is just advisory
// Execute `deployTokenContract(...)` with the following parameters to deploy
// your very own FixedSupplyToken contract:
//   symbol         symbol
//   name           name
//   decimals       number of decimal places for the token contract
//   totalSupply    the fixed token total supply
//
// For example, deploying a FixedSupplyToken contract with a `totalSupply`
// of 1,000.000000000000000000 tokens:
//   symbol         "ME"
//   name           "My Token"
//   decimals       18
//   initialSupply  10000000000000000000000 = 1,000.000000000000000000 tokens
//
// The TokenDeployed() event is logged with the following parameters:
//   owner          the account that execute this transaction
//   token          the newly deployed FixedSupplyToken address
//   symbol         symbol
//   name           name
//   decimals       number of decimal places for the token contract
//   totalSupply    the fixed token total supply
// ----------------------------------------------------------------------------
contract TokenFactory is Operated {

    address public newAddress;
    mapping(address => bool) public isChild;
    address[] public children;

    event FactoryDeprecated(address _newAddress);
    event TokenDeployed(address indexed owner, address indexed token, string symbol, string name, uint8 decimals, uint totalSupply, bool mintable, bool transferable);

    constructor() public {
        super.initOperated(msg.sender);
    }
    function numberOfChildren() public view returns (uint) {
        return children.length;
    }
    function deprecateFactory(address _newAddress) public onlyOwner {
        require(_newAddress == address(0));
        emit FactoryDeprecated(_newAddress);
        newAddress = _newAddress;
    }

    function deployTokenContract(address _owner, string memory _symbol, string memory _name, uint8 _decimals, uint _totalSupply, bool _mintable, bool _transferable) public onlyOperator returns (DreamFramesToken token) {
        require(_decimals <= 27);
        require(_totalSupply > 0);
        token = new DreamFramesToken();
        token.init(_owner, _symbol, _name, _decimals, _totalSupply, _mintable, _transferable);
        isChild[address(token)] = true;
        children.push(address(token));
        emit TokenDeployed(_owner, address(token), _symbol, _name, _decimals, _totalSupply, _mintable, _transferable);
    }

    receive() external payable {
        revert();
    }

    function recoverTokens(address _token, uint _tokens) public payable onlyOwner {
        if (_token == address(0)) {
            owner.transfer((_tokens == 0 ? address(this).balance : _tokens));
        } else {
            ERC20Interface(_token).transfer(owner, _tokens == 0 ? ERC20Interface(_token).balanceOf(address(this)) : _tokens);
        }
    }
}