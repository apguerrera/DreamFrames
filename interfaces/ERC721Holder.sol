pragma solidity ^0.6.12;

import "../interfaces/ERC721Receiver.sol";


interface ERC721Holder is ERC721Receiver {
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
