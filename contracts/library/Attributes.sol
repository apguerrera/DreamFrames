pragma solidity ^0.6.12;
// ----------------------------------------------------------------------------
// Attributes Data Structure
// ----------------------------------------------------------------------------
library Attributes {
    struct Value {
        uint timestamp;
        uint index;
        string value;
    }
    struct Data {
        bool initialised;
        mapping(string => Value) entries;
        string[] index;
    }

    event AttributeAdded(uint256 indexed tokenId, string key, string value, uint totalAfter);
    event AttributeRemoved(uint256 indexed tokenId, string key, uint totalAfter);
    event AttributeUpdated(uint256 indexed tokenId, string key, string value);

    function init(Data storage self) internal {
        require(!self.initialised);
        self.initialised = true;
    }
    function hasKey(Data storage self, string memory key) internal view returns (bool) {
        return self.entries[key].timestamp > 0;
    }
    function add(Data storage self, uint256 tokenId, string memory key, string memory value) internal {
        require(self.entries[key].timestamp == 0);
        self.index.push(key);
        self.entries[key] = Value(block.timestamp, self.index.length - 1, value);
        emit AttributeAdded(tokenId, key, value, self.index.length);
    }
    function remove(Data storage self, uint256 tokenId, string memory key) internal {
        require(self.entries[key].timestamp > 0);
        uint removeIndex = self.entries[key].index;
        emit AttributeRemoved(tokenId, key, self.index.length - 1);
        uint lastIndex = self.index.length - 1;
        string memory lastIndexKey = self.index[lastIndex];
        self.index[removeIndex] = lastIndexKey;
        self.entries[lastIndexKey].index = removeIndex;
        delete self.entries[key];
        if (self.index.length > 0) {
            self.index.pop();
        }
    }
    function removeAll(Data storage self, uint256 tokenId) internal {
        if (self.initialised) {
            while (self.index.length > 0) {
                uint lastIndex = self.index.length - 1;
                string memory lastIndexKey = self.index[lastIndex];
                emit AttributeRemoved(tokenId, lastIndexKey, lastIndex);
                delete self.entries[lastIndexKey];
                self.index.pop();
            }
        }
    }
    function setValue(Data storage self, uint256 tokenId, string memory key, string memory value) internal {
        Value storage _value = self.entries[key];
        require(_value.timestamp > 0);
        _value.timestamp = block.timestamp;
        emit AttributeUpdated(tokenId, key, value);
        _value.value = value;
    }
    function length(Data storage self) internal view returns (uint) {
        return self.index.length;
    }
}