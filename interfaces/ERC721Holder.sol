pragma solidity ^0.5.4;

import "../interfaces/ERC721Receiver.sol";


contract ERC721Holder is ERC721Receiver {
  function onERC721Received(
    address,
    address,
    uint256,
    bytes memory
  )
    public
    returns (bytes4)
  {
    return ERC721_RECEIVED;
  }
}
