/**
 *Submitted for verification at Etherscan.io on 2019-10-25
*/

pragma solidity ^0.5.11;

// For array of strings in the parameter. Not working correctly. pragma experimental ABIEncoderV2;

// ----------------------------------------------------------------------------
// GazeCoin Metaverse Asset (ERC721 Non-Fungible Token)
//
// Deployed to : v10 0x5C31be9C2ca80788274880030344230dFB8DFC4A on Ropsten
//
// TODO:
//   * Create a list of allowable attributes, optional or mandatory
//     with a defined list or unlimited with certain attributes updatable
//     by the token contract owner
//   * Allow token owner to permission secondary accounts
//
// Enjoy.
//
// (c) BokkyPooBah / Bok Consulting Pty Ltd for GazeCoin 2019. The MIT Licence.
// ----------------------------------------------------------------------------





/**
 * @dev Interface of the ERC165 standard, as defined in the
 * [EIP](https://eips.ethereum.org/EIPS/eip-165).
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others (`ERC165Checker`).
 *
 * For an implementation, see `ERC165`.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of NFTs in `owner`'s account.
     */
    function balanceOf(address owner) public view returns (uint256 balance);

    /**
     * @dev Returns the owner of the NFT specified by `tokenId`.
     */
    function ownerOf(uint256 tokenId) public view returns (address owner);

    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     *
     *
     * Requirements:
     * - `from`, `to` cannot be zero.
     * - `tokenId` must be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this
     * NFT by either `approve` or `setApproveForAll`.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public;
    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * Requirements:
     * - If the caller is not `from`, it must be approved to move this NFT by
     * either `approve` or `setApproveForAll`.
     */
    function transferFrom(address from, address to, uint256 tokenId) public;
    function approve(address to, uint256 tokenId) public;
    function getApproved(uint256 tokenId) public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);


    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
contract IERC721Enumerable is IERC721 {
    function totalSupply() public view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);

    function tokenByIndex(uint256 index) public view returns (uint256);
}


/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
contract IERC721Receiver {
    /**
     * @notice Handle the receipt of an NFT
     * @dev The ERC721 smart contract calls this function on the recipient
     * after a `safeTransfer`. This function MUST return the function selector,
     * otherwise the caller will revert the transaction. The selector to be
     * returned can be obtained as `this.onERC721Received.selector`. This
     * function MAY throw to revert and reject the transfer.
     * Note: the ERC721 contract address is always the message sender.
     * @param operator The address which called `safeTransferFrom` function
     * @param from The address which previously owned the token
     * @param tokenId The NFT identifier which is being transferred
     * @param data Additional data with no specified format
     * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
     */
    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
    public returns (bytes4);
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

/**
 * @dev Collection of functions related to the address type,
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * > It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}


/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
 * directly accessed.
 */
library Counters {
    using SafeMath for uint256;

    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        counter._value += 1;
    }

    function decrement(Counter storage counter) internal {
        counter._value = counter._value.sub(1);
    }
}


/**
 * @dev Implementation of the `IERC165` interface.
 *
 * Contracts may inherit from this and call `_registerInterface` to declare
 * their support of an interface.
 */
contract ERC165 is IERC165 {
    /*
     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
     */
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    /**
     * @dev Mapping of interface ids to whether or not it's supported.
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () internal {
        // Derived contracts need only register support for their own interfaces,
        // we register support for ERC165 itself here
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    /**
     * @dev See `IERC165.supportsInterface`.
     *
     * Time complexity O(1), guaranteed to always use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    /**
     * @dev Registers the contract as an implementer of the interface defined by
     * `interfaceId`. Support of the actual ERC165 interface is automatic and
     * registering its interface id is not required.
     *
     * See `IERC165.supportsInterface`.
     *
     * Requirements:
     *
     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
     */
    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}

/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://eips.ethereum.org/EIPS/eip-721
 */
contract ERC721 is ERC165, IERC721 {
    using SafeMath for uint256;
    using Address for address;
    using Counters for Counters.Counter;

    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    // Mapping from token ID to owner
    mapping (uint256 => address) private _tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to number of owned token
    mapping (address => Counters.Counter) private _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

    /*
     *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
     *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
     *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
     *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
     *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
     *
     *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
     *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
     */
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    constructor () public {
        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721);
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param owner address to query the balance of
     * @return uint256 representing the amount owned by the passed address
     */
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");

        return _ownedTokensCount[owner].current();
    }

    /**
     * @dev Gets the owner of the specified token ID.
     * @param tokenId uint256 ID of the token to query the owner of
     * @return address currently marked as the owner of the given token ID
     */
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");

        return owner;
    }

    /**
     * @dev Approves another address to transfer the given token ID
     * The zero address indicates there is no approved address.
     * There can only be one approved address per token at a given time.
     * Can only be called by the token owner or an approved operator.
     * @param to address to be approved for the given token ID
     * @param tokenId uint256 ID of the token to be approved
     */
    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    /**
     * @dev Gets the approved address for a token ID, or zero if no address set
     * Reverts if the token ID does not exist.
     * @param tokenId uint256 ID of the token to query the approval of
     * @return address currently approved for the given token ID
     */
    function getApproved(uint256 tokenId) public view returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev Sets or unsets the approval of a given operator
     * An operator is allowed to transfer all tokens of the sender on their behalf.
     * @param to operator address to set the approval
     * @param approved representing the status of the approval to be set
     */
    function setApprovalForAll(address to, bool approved) public {
        require(to != msg.sender, "ERC721: approve to caller");

        _operatorApprovals[msg.sender][to] = approved;
        emit ApprovalForAll(msg.sender, to, approved);
    }

    /**
     * @dev Tells whether an operator is approved by a given owner.
     * @param owner owner address which you want to query the approval of
     * @param operator operator address which you want to query the approval of
     * @return bool whether the given operator is approved by the given owner
     */
    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev Transfers the ownership of a given token ID to another address.
     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
     * Requires the msg.sender to be the owner, approved, or operator.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     */
    function transferFrom(address from, address to, uint256 tokenId) public {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");

        _transferFrom(from, to, tokenId);
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     * Requires the msg.sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     * Requires the msg.sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes data to send along with a safe transfer check
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns whether the specified token exists.
     * @param tokenId uint256 ID of the token to query the existence of
     * @return bool whether the token exists
     */
    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    /**
     * @dev Returns whether the given spender can transfer a given token ID.
     * @param spender address of the spender to query
     * @param tokenId uint256 ID of the token to be transferred
     * @return bool whether the msg.sender is approved for the given token ID,
     * is an operator of the owner, or is the owner of the token
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Internal function to mint a new token.
     * Reverts if the given token ID already exists.
     * @param to The address that will own the minted token
     * @param tokenId uint256 ID of the token to be minted
     */
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to].increment();

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Internal function to burn a specific token.
     * Reverts if the token does not exist.
     * Deprecated, use _burn(uint256) instead.
     * @param owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned
     */
    function _burn(address owner, uint256 tokenId) internal {
        require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");

        _clearApproval(tokenId);

        _ownedTokensCount[owner].decrement();
        _tokenOwner[tokenId] = address(0);

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Internal function to burn a specific token.
     * Reverts if the token does not exist.
     * @param tokenId uint256 ID of the token being burned
     */
    function _burn(uint256 tokenId) internal {
        _burn(ownerOf(tokenId), tokenId);
    }

    /**
     * @dev Internal function to transfer ownership of a given token ID to another address.
     * As opposed to transferFrom, this imposes no restrictions on msg.sender.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     */
    function _transferFrom(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _clearApproval(tokenId);

        _ownedTokensCount[from].decrement();
        _ownedTokensCount[to].increment();

        _tokenOwner[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Internal function to invoke `onERC721Received` on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * This function is deprecated.
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
        internal returns (bool)
    {
        if (!to.isContract()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }

    /**
     * @dev Private function to clear current approval of a given token ID.
     * @param tokenId uint256 ID of the token to be transferred
     */
    function _clearApproval(uint256 tokenId) private {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }
}

/**
 * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
    // Mapping from owner to list of owned token IDs
    mapping(address => uint256[]) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    /*
     *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
     *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
     *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
     *
     *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
     */
    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;

    /**
     * @dev Constructor function.
     */
    constructor () public {
        // register the supported interface to conform to ERC721Enumerable via ERC165
        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
    }

    /**
     * @dev Gets the token ID at a given index of the tokens list of the requested owner.
     * @param owner address owning the tokens list to be accessed
     * @param index uint256 representing the index to be accessed of the requested tokens list
     * @return uint256 token ID at the given index of the tokens list owned by the requested address
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }

    /**
     * @dev Gets the total amount of tokens stored by the contract.
     * @return uint256 representing the total amount of tokens
     */
    function totalSupply() public view returns (uint256) {
        return _allTokens.length;
    }

    /**
     * @dev Gets the token ID at a given index of all the tokens in this contract
     * Reverts if the index is greater or equal to the total number of tokens.
     * @param index uint256 representing the index to be accessed of the tokens list
     * @return uint256 token ID at the given index of the tokens list
     */
    function tokenByIndex(uint256 index) public view returns (uint256) {
        require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[index];
    }

    /**
     * @dev Internal function to transfer ownership of a given token ID to another address.
     * As opposed to transferFrom, this imposes no restrictions on msg.sender.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     */
    function _transferFrom(address from, address to, uint256 tokenId) internal {
        super._transferFrom(from, to, tokenId);

        _removeTokenFromOwnerEnumeration(from, tokenId);

        _addTokenToOwnerEnumeration(to, tokenId);
    }

    /**
     * @dev Internal function to mint a new token.
     * Reverts if the given token ID already exists.
     * @param to address the beneficiary that will own the minted token
     * @param tokenId uint256 ID of the token to be minted
     */
    function _mint(address to, uint256 tokenId) internal {
        super._mint(to, tokenId);

        _addTokenToOwnerEnumeration(to, tokenId);

        _addTokenToAllTokensEnumeration(tokenId);
    }

    /**
     * @dev Internal function to burn a specific token.
     * Reverts if the token does not exist.
     * Deprecated, use _burn(uint256) instead.
     * @param owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned
     */
    function _burn(address owner, uint256 tokenId) internal {
        super._burn(owner, tokenId);

        _removeTokenFromOwnerEnumeration(owner, tokenId);
        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
        _ownedTokensIndex[tokenId] = 0;

        _removeTokenFromAllTokensEnumeration(tokenId);
    }

    /**
     * @dev Gets the list of token IDs of the requested owner.
     * @param owner address owning the tokens
     * @return uint256[] List of token IDs owned by the requested address
     */
    function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
        return _ownedTokens[owner];
    }

    /**
     * @dev Private function to add a token to this extension's ownership-tracking data structures.
     * @param to address representing the new owner of the given token ID
     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    /**
     * @dev Private function to add a token to this extension's token tracking data structures.
     * @param tokenId uint256 ID of the token to be added to the tokens list
     */
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    /**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        _ownedTokens[from].length--;

        // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
        // lastTokenId, or just over the end of the array if the token was the last one).
    }

    /**
     * @dev Private function to remove a token from this extension's token tracking data structures.
     * This has O(1) time complexity, but alters the order of the _allTokens array.
     * @param tokenId uint256 ID of the token to be removed from the tokens list
     */
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _allTokens.length.sub(1);
        uint256 tokenIndex = _allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        _allTokens.length--;
        _allTokensIndex[tokenId] = 0;
    }
}


/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
contract IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;
    bool private initialised;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function initOwned(address _owner) internal {
        require(!initialised);
        owner = _owner;
        initialised = true;
    }
    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
    function transferOwnershipImmediately(address _newOwner) public onlyOwner {
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}


// ----------------------------------------------------------------------------
// Metadata
// ----------------------------------------------------------------------------
contract MyERC721Metadata is ERC165, ERC721, IERC721Metadata, Owned {
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

    function setBaseURI(string memory uri) public onlyOwner {
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
            self.index.length--;
        }
    }
    function removeAll(Data storage self, uint256 tokenId) internal {
        if (self.initialised) {
            while (self.index.length > 0) {
                uint lastIndex = self.index.length - 1;
                string memory lastIndexKey = self.index[lastIndex];
                emit AttributeRemoved(tokenId, lastIndexKey, lastIndex);
                delete self.entries[lastIndexKey];
                self.index.length--;
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


contract GazeCoinGoobers is ERC721Enumerable, MyERC721Metadata {
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

    constructor() MyERC721Metadata("GazeCoin Goobers v10", "GOOBv10") public {
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
    //         addAttribute(newTokenId, keys[i], values[i]);
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
    // function getKeys(uint256 tokenId) public view returns (string[] memory) {
    //     Attributes.Data storage attributes = attributesByTokenIds[tokenId];
    //     if (!attributes.initialised) {
    //         string[] memory empty;
    //         return empty;
    //     } else {
    //         return attributes.index;
    //     }
    // }
    // function getKey(uint256 tokenId, uint _index) public view returns (string memory) {
    //     Attributes.Data storage attributes = attributesByTokenIds[tokenId];
    //     if (attributes.initialised) {
    //         if (_index < attributes.index.length) {
    //             return attributes.index[_index];
    //         }
    //     }
    //     return "";
    // }
    // function getValue(uint256 tokenId, string memory key) public view returns (bool _exists, uint _index, string memory _value) {
    //     Attributes.Data storage attributes = attributesByTokenIds[tokenId];
    //     if (!attributes.initialised) {
    //         return (false, 0, "");
    //     } else {
    //         Attributes.Value memory attribute = attributes.entries[key];
    //         return (attribute.exists, attribute.index, attribute.value);
    //     }
    // }
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
        require(isOwnerOf(tokenId, msg.sender), "GazeCoinGoobers: add attribute of token that is not own");
        require(keccak256(abi.encodePacked(key)) != keccak256(abi.encodePacked(TYPE_KEY)));
        Attributes.Data storage attributes = attributesByTokenIds[tokenId];
        if (!attributes.initialised) {
            attributes.init();
        }
        require(attributes.entries[key].timestamp == 0);
        attributes.add(tokenId, key, value);
    }
    function setAttribute(uint256 tokenId, string memory key, string memory value) public {
        require(isOwnerOf(tokenId, msg.sender), "GazeCoinGoobers: set attribute of token that is not own");
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
        require(isOwnerOf(tokenId, msg.sender), "GazeCoinGoobers: remove attribute of token that is not own");
        require(keccak256(abi.encodePacked(key)) != keccak256(abi.encodePacked(TYPE_KEY)));
        Attributes.Data storage attributes = attributesByTokenIds[tokenId];
        require(attributes.initialised);
        attributes.remove(tokenId, key);
    }
    function updateAttribute(uint256 tokenId, string memory key, string memory value) public {
        require(isOwnerOf(tokenId, msg.sender), "GazeCoinGoobers: update attribute of token that is not own");
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
        require(account != address(0), "GazeCoinGoobers: cannot add null secondary account");
        Accounts.Data storage accounts = secondaryAccounts[msg.sender];
        if (!accounts.initialised) {
            accounts.init();
        }
        require(accounts.entries[account].timestamp == 0);
        accounts.add(msg.sender, account);
    }
    function removeSecondaryAccount(address account) public {
        require(account != address(0), "GazeCoinGoobers: cannot remove null secondary account");
        Accounts.Data storage accounts = secondaryAccounts[msg.sender];
        require(accounts.initialised);
        accounts.remove(msg.sender, account);
    }
}