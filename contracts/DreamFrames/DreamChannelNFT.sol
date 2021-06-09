pragma solidity ^0.6.12;

//import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../Utils/MyERC721Metadata.sol";
import "../library/Accounts.sol";
import "../library/Attributes.sol";
import "../library/Counters.sol";

contract DreamChannelNFT is /* ERC721Enumerable */ MyERC721Metadata {
    using Attributes for Attributes.Data;
    using Attributes for Attributes.Value;
    using Counters for Counters.Counter;
    using Accounts for Accounts.Data;
    using Accounts for Accounts.Account;

    string public constant TYPE_KEY = "type";
    string public constant SUBTYPE_KEY = "subtype";
    string public constant NAME_KEY = "name";
    string public constant DESCRIPTION_KEY = "description";
    string public constant TAGS_KEY = "tags";

    mapping(uint256 => Attributes.Data) private attributesByTokenIds;
    Counters.Counter private _tokenIds;
    mapping(address => Accounts.Data) private secondaryAccounts;

    // Duplicated from Attributes for NFT contract ABI to contain events
    event AttributeAdded(uint256 indexed tokenId, string key, string value, uint totalAfter);
    event AttributeRemoved(uint256 indexed tokenId, string key, uint totalAfter);
    event AttributeUpdated(uint256 indexed tokenId, string key, string value);

    event AccountAdded(address owner, address account, uint totalAfter);
    event AccountRemoved(address owner, address account, uint totalAfter);
    // event AccountUpdated(uint256 indexed tokenId, address owner, address account);

    constructor() MyERC721Metadata("DreamChannel NFT", "DCNFT") public {
    }

    // Mint and burn

    /**
     * @dev Mint token
     *
     * @param _to address of token owner
     * @param _type Type of token, mandatory
     * @param _subtype Subtype of token, optional
     * @param _name Name of token, optional
     * @param _description Description of token, optional
     * @param _tags Tags of token, optional
     */
    function mint(address _to, string memory _type, string memory _subtype, string memory _name, string memory _description, string memory _tags) public returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(_to, newTokenId);

        bytes memory typeInBytes = bytes(_type);
        require(typeInBytes.length > 0);

        Attributes.Data storage attributes = attributesByTokenIds[newTokenId];
        attributes.init();
        attributes.add(newTokenId, TYPE_KEY, _type);

        bytes memory subtypeInBytes = bytes(_subtype);
        if (subtypeInBytes.length > 0) {
            attributes.add(newTokenId, SUBTYPE_KEY, _subtype);
        }

        bytes memory nameInBytes = bytes(_name);
        if (nameInBytes.length > 0) {
            attributes.add(newTokenId, NAME_KEY, _name);
        }

        bytes memory descriptionInBytes = bytes(_description);
        if (descriptionInBytes.length > 0) {
            attributes.add(newTokenId, DESCRIPTION_KEY, _description);
        }

        bytes memory tagsInBytes = bytes(_tags);
        if (tagsInBytes.length > 0) {
            attributes.add(newTokenId, TAGS_KEY, _tags);
        }

        return newTokenId;
    }
    // BELOW DOES NOT WORK CORRECTLY
    // function mintWithAttributes(address to, string[] memory keys, string[] memory values) public returns (uint256) {
    //     require(keys.length == values.length);
    //     _tokenIds.increment();
    //     uint256 newTokenId = _tokenIds.current();
    //     _mint(to, newTokenId);
    //     for (uint256 i = 0; i < keys.length; i++) {
    //         addAttribute(newTokeis nId, keys[i], values[i]);
    //     }
    //     return newTokenId;
    // }
    // function mintWithTokenURI(address to, string memory tokenURI) public returns (uint256) {
    //     _tokenIds.increment();
    //
    //     uint256 newTokenId = _tokenIds.current();
    //     _mint(to, newTokenId);
    //     _setTokenURI(newTokenId, tokenURI);
    //
    //     return newTokenId;
    // }
    function burn(uint256 tokenId) public {
        // TODO - attributes.removeAll(...)
        _burn(msg.sender, tokenId);
        Attributes.Data storage attributes = attributesByTokenIds[tokenId];
        if (attributes.initialised) {
            attributes.removeAll(tokenId);
            delete attributesByTokenIds[tokenId];
        }
    }

    // Attributes
    function numberOfAttributes(uint256 tokenId) public view returns (uint) {
        Attributes.Data storage attributes = attributesByTokenIds[tokenId];
        if (!attributes.initialised) {
            return 0;
        } else {
            return attributes.length();
        }
    }
    // NOTE - Solidity returns an incorrect value
//    function getKeys(uint256 tokenId) public view returns (string[] memory) {
//        Attributes.Data storage attributes = attributesByTokenIds[tokenId];
//       if (!attributes.initialised) {
//           string[] memory empty;
//           return empty;
//       } else {
//           return attributes.index;
//       }
//     }
    function getKey(uint256 tokenId, uint _index) public view returns (string memory) {
         Attributes.Data storage attributes = attributesByTokenIds[tokenId];
         if (attributes.initialised) {
             if (_index < attributes.index.length) {
                 return attributes.index[_index];
             }
         }
         return "";
     }

     function getValue(uint256 tokenId, string memory key) public view returns (uint _exists, uint _index, string memory _value) {
         Attributes.Data storage attributes = attributesByTokenIds[tokenId];
         if (!attributes.initialised) {
             return (0, 0, "");
         } else {
             Attributes.Value memory attribute = attributes.entries[key];
             return (attribute.timestamp, attribute.index, attribute.value);
         }
     }
    function getAttributeByIndex(uint256 tokenId, uint256 _index) public view returns (string memory _key, string memory _value, uint timestamp) {
        Attributes.Data storage attributes = attributesByTokenIds[tokenId];
        if (attributes.initialised) {
            if (_index < attributes.index.length) {
                string memory key = attributes.index[_index];
                bytes memory keyInBytes = bytes(key);
                if (keyInBytes.length > 0) {
                    Attributes.Value memory attribute = attributes.entries[key];
                    return (key, attribute.value, attribute.timestamp);
                }
            }
        }
        return ("", "", 0);
    }
    function addAttribute(uint256 tokenId, string memory key, string memory value) public {
        require(isOwnerOf(tokenId, msg.sender), "DreamChannelNFT: add attribute of token that is not own");
        require(keccak256(abi.encodePacked(key)) != keccak256(abi.encodePacked(TYPE_KEY)));
        Attributes.Data storage attributes = attributesByTokenIds[tokenId];
        if (!attributes.initialised) {
            attributes.init();
        }
        require(attributes.entries[key].timestamp == 0);
        attributes.add(tokenId, key, value);
    }
    function setAttribute(uint256 tokenId, string memory key, string memory value) public {
        require(isOwnerOf(tokenId, msg.sender), "DreamChannelNFT: set attribute of token that is not own");
        require(keccak256(abi.encodePacked(key)) != keccak256(abi.encodePacked(TYPE_KEY)));
        Attributes.Data storage attributes = attributesByTokenIds[tokenId];
        if (!attributes.initialised) {
            attributes.init();
        }
        if (attributes.entries[key].timestamp > 0) {
            attributes.setValue(tokenId, key, value);
        } else {
            attributes.add(tokenId, key, value);
        }
    }
    function removeAttribute(uint256 tokenId, string memory key) public {
        require(isOwnerOf(tokenId, msg.sender), "DreamChannelNFT: remove attribute of token that is not own");
        require(keccak256(abi.encodePacked(key)) != keccak256(abi.encodePacked(TYPE_KEY)));
        Attributes.Data storage attributes = attributesByTokenIds[tokenId];
        require(attributes.initialised);
        attributes.remove(tokenId, key);
    }
    function updateAttribute(uint256 tokenId, string memory key, string memory value) public {
        require(isOwnerOf(tokenId, msg.sender), "DreamChannelNFT: update attribute of token that is not own");
        require(keccak256(abi.encodePacked(key)) != keccak256(abi.encodePacked(TYPE_KEY)));
        Attributes.Data storage attributes = attributesByTokenIds[tokenId];
        require(attributes.initialised);
        require(attributes.entries[key].timestamp > 0);
        attributes.setValue(tokenId, key, value);
    }

    function isOwnerOf(uint tokenId, address account) public view returns (bool) {
        address owner = ownerOf(tokenId);
        if (owner == account) {
            return true;
        } else {
            Accounts.Data storage accounts = secondaryAccounts[owner];
            if (accounts.initialised) {
                if (accounts.hasKey(account)) {
                    return true;
                }
            }
        }
        return false;
    }
    function addSecondaryAccount(address account) public {
        require(account != address(0), "DreamChannelNFT: cannot add null secondary account");
        Accounts.Data storage accounts = secondaryAccounts[msg.sender];
        if (!accounts.initialised) {
            accounts.init();
        }
        require(accounts.entries[account].timestamp == 0);
        accounts.add(msg.sender, account);
    }
    function removeSecondaryAccount(address account) public {
        require(account != address(0), "DreamChannelNFT: cannot remove null secondary account");
        Accounts.Data storage accounts = secondaryAccounts[msg.sender];
        require(accounts.initialised);
        accounts.remove(msg.sender, account);
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public{
        require(isOwnerOf(tokenId, msg.sender), "DreamChannelNFT: set Token URI of token that is not own");
        _setTokenURI(tokenId, _tokenURI);
    }

    
}