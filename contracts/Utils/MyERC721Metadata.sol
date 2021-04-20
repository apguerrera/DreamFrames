pragma solidity ^0.5.4;

import "@openzeppelin/contracts/introspection/ERC165.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../Shared/Owned.sol";

contract MyERC721Metadata is ERC165, ERC721, Owned {
    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    /*
     *     bytes4(keccak256('name()')) == 0x06fdde03
     *     bytes4(keccak256('symbol()')) == 0x95d89b41
     *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
     *
     *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
     */
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;

    string public baseURI = "http://multiverse.gazecoin.io/api/asset/";

    /**
     * @dev Constructor function
     */
    constructor (string memory name, string memory symbol) public {
        initOwned(msg.sender);

        _name = name;
        _symbol = symbol;

        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
    }

    function uintToBytes(uint256 num) internal pure returns (bytes memory b) {
        if (num == 0) {
            b = new bytes(1);
            b[0] = byte(uint8(48));
        } else {
            uint256 j = num;
            uint256 length;
            while (j != 0) {
                length++;
                j /= 10;
            }
            b = new bytes(length);
            uint k = length - 1;
            while (num != 0) {
                b[k--] = byte(uint8(48 + num % 10));
                num /= 10;
            }
        }
    }

    function setBaseURI(string memory uri) public /* onlyOwner */ {
        baseURI = uri;
    }

    /**
     * @dev Gets the token name.
     * @return string representing the token name
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * @dev Gets the token symbol.
     * @return string representing the token symbol
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns an URI for a given token ID.
     * Throws if the token ID does not exist. May return an empty string.
     * @param tokenId uint256 ID of the token to query
     */
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory url = _tokenURIs[tokenId];
        bytes memory urlAsBytes = bytes(url);
        if (urlAsBytes.length == 0) {
            bytes memory baseURIAsBytes = bytes(baseURI);
            bytes memory tokenIdAsBytes = uintToBytes(tokenId);
            bytes memory b = new bytes(baseURIAsBytes.length + tokenIdAsBytes.length);
            uint256 i;
            uint256 j;
            for (i = 0; i < baseURIAsBytes.length; i++) {
                b[j++] = baseURIAsBytes[i];
            }
            for (i = 0; i < tokenIdAsBytes.length; i++) {
                b[j++] = tokenIdAsBytes[i];
            }
            return string(b);
        } else {
            return _tokenURIs[tokenId];
        }
    }

    /**
     * @dev Internal function to set the token URI for a given token.
     * Reverts if the token ID does not exist.
     * @param tokenId uint256 ID of the token to set its URI
     * @param uri string URI to assign
     */
    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = uri;
    }

    // BK NOTE - Disable as not required currently
    // function setTokenURI(uint256 tokenId, string memory uri) public {
    //     require(ownerOf(tokenId) == msg.sender, "ERC721Metadata: set URI of token that is not own");
    //     _setTokenURI(tokenId, uri);
    // }

    /**
     * @dev Internal function to burn a specific token.
     * Reverts if the token does not exist.
     * Deprecated, use _burn(uint256) instead.
     * @param owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned by the msg.sender
     */
    function _burn(address owner, uint256 tokenId) internal {
        super._burn(owner, tokenId);

        // Clear metadata (if any)
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}
