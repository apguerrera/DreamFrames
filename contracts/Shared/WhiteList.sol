pragma solidity ^0.5.4;

// ----------------------------------------------------------------------------
// Dream Frames White List
//
// Deployed to:
//
// Enjoy.
//
// (c) BokkyPooBah / Bok Consulting Pty Ltd for GazeCoin 2018. The MIT Licence.
// (c) Adrian Guerrera / Deepyr Pty Ltd for Dream Frames 2019. The MIT Licence.
// ----------------------------------------------------------------------------

import "../Shared/Operated.sol";
import "../../interfaces/WhiteListInterface.sol";


// ----------------------------------------------------------------------------
// White List - on list or not
// ----------------------------------------------------------------------------
contract WhiteList is WhiteListInterface, Operated {
    mapping(address => bool) public whiteList;

    event AccountListed(address indexed account, bool status);

    constructor() public {
        initOperated(msg.sender);
    }

    function isInWhiteList(address account) public view returns (bool) {
        return whiteList[account];
    }

    function add(address[] memory accounts) public onlyOperator {
        require(accounts.length != 0);
        for (uint i = 0; i < accounts.length; i++) {
            require(accounts[i] != address(0));
            if (!whiteList[accounts[i]]) {
                whiteList[accounts[i]] = true;
                emit AccountListed(accounts[i], true);
            }
        }
    }
    function remove(address[] memory accounts) public onlyOperator {
        require(accounts.length != 0);
        for (uint i = 0; i < accounts.length; i++) {
            require(accounts[i] != address(0));
            if (whiteList[accounts[i]]) {
                delete whiteList[accounts[i]];
                emit AccountListed(accounts[i], false);
            }
        }
    }
}
