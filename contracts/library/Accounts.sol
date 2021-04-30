pragma solidity ^0.6.12;
// ----------------------------------------------------------------------------
// Secondary Accounts Data Structure
// ----------------------------------------------------------------------------
library Accounts {
    struct Account {
        uint timestamp;
        uint index;
        address account;
    }
    struct Data {
        bool initialised;
        mapping(address => Account) entries;
        address[] index;
    }

    event AccountAdded(address owner, address account, uint totalAfter);
    event AccountRemoved(address owner, address account, uint totalAfter);
    // event AccountUpdated(uint256 indexed tokenId, address owner, address account);

    function init(Data storage self) internal {
        require(!self.initialised);
        self.initialised = true;
    }
    function hasKey(Data storage self, address account) internal view returns (bool) {
        return self.entries[account].timestamp > 0;
    }
    function add(Data storage self, address owner, address account) internal {
        require(self.entries[account].timestamp == 0);
        self.index.push(account);
        self.entries[account] = Account(block.timestamp, self.index.length - 1, account);
        emit AccountAdded(owner, account, self.index.length);
    }
    function remove(Data storage self, address owner, address account) internal {
        require(self.entries[account].timestamp > 0);
        uint removeIndex = self.entries[account].index;
        emit AccountRemoved(owner, account, self.index.length - 1);
        uint lastIndex = self.index.length - 1;
        address lastIndexKey = self.index[lastIndex];
        self.index[removeIndex] = lastIndexKey;
        self.entries[lastIndexKey].index = removeIndex;
        delete self.entries[account];
        if (self.index.length > 0) {
            self.index.length--;
        }
    }
    function removeAll(Data storage self, address owner) internal {
        if (self.initialised) {
            while (self.index.length > 0) {
                uint lastIndex = self.index.length - 1;
                address lastIndexKey = self.index[lastIndex];
                emit AccountRemoved(owner, lastIndexKey, lastIndex);
                delete self.entries[lastIndexKey];
                self.index.length--;
            }
        }
    }
    // function setValue(Data storage self, uint256 tokenId, string memory key, string memory value) internal {
    //     Value storage _value = self.entries[key];
    //     require(_value.timestamp > 0);
    //     _value.timestamp = block.timestamp;
    //     emit AttributeUpdated(tokenId, key, value);
    //     _value.value = value;
    // }
    function length(Data storage self) internal view returns (uint) {
        return self.index.length;
    }
}