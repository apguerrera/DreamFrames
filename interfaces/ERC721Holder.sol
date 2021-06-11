pragma solidity ^0.6.12;

import "../interfaces/ERC721Receiver.sol";


contract ERC721Holder is ERC721Receiver {
  bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;

  function onERC721Received(
    address,
    address,
    uint256,
    bytes memory
  )
    public
    override
    returns (bytes4)
  {
    return ERC721_RECEIVED;
  }
}
