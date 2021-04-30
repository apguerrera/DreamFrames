pragma solidity ^0.6.12;

// ----------------------------------------------------------------------------
// DreamFrameSecurityToken Contract
//
// Deployed to : {TBA}
//
// Enjoy.
//
// (c) Adrian Guerrera / Deepyr Pty Ltd for Dreamframes 2019. The MIT Licence.
// ----------------------------------------------------------------------------

import "./DividendToken.sol";
import "../Shared/IERC1594.sol";
import "../Shared/CanSendCodes.sol";

// ----------------------------------------------------------------------------
// Security Token
// ----------------------------------------------------------------------------
contract DreamFrameSecurityToken is DividendToken, CanSendCodes, IERC1594 {

    // Transfers
    function transferWithData(address _to, uint256 _value, bytes calldata _data) external {
       transfer(_to, _value);
    }
    function transferFromWithData(address _from, address _to, uint256 _value, bytes calldata _data) external{
      transferFrom(_from, _to, _value);
    }

    // Token Issuance
    function isIssuable() external view returns (bool) {
        return data.mintable;
    }

    function issue(address _tokenHolder, uint256 _value, bytes calldata  _data) external{
       _updateAccount(_tokenHolder);
       require(data.mint(_tokenHolder, _value, false));
       emit Issued(msg.sender, _tokenHolder, _value, _data);
    }

    // Token Redemption
    function redeem(uint256 _value, bytes calldata _data) external {
      _redeemFrom(msg.sender, _value, _data);
    }
    function redeemFrom(address _tokenHolder, uint256 _value, bytes calldata _data) external{
      _redeemFrom(_tokenHolder, _value, _data);
    }
    function _redeemFrom(address _tokenHolder, uint256 _value, bytes memory _data) internal {
      _updateAccount(_tokenHolder);
      emit Redeemed(msg.sender,_tokenHolder,_value,_data);  // AG To check correct senders
    }

    // Transfer Validity
    function canTransfer(address _to, uint256 _value, bytes calldata _data) external view returns (bool, byte, bytes32){
      bool success = _canTransfer(msg.sender, _to, _value);
      if (success == true) {
        return (true,TRANSFER_VERIFIED_ONCHAIN_APPROVAL,"");
      } else {
        return(false,TRANSFER_BLOCKED_TOKEN_RESTRICTION,"");
      }
    }

    function canTransferFrom(address _from, address _to, uint256 _value, bytes calldata _data) external view returns (bool, byte, bytes32) {
      bool success = _canTransfer(_from, _to, _value);
      if (success == true) {
        return (true,TRANSFER_VERIFIED_ONCHAIN_APPROVAL,"");
      } else {
        return(false,TRANSFER_BLOCKED_TOKEN_RESTRICTION,"");
      }
    }


}
