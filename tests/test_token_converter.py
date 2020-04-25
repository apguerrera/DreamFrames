from brownie import accounts, web3, Wei, reverts
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract

ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'


# reset the chain after every test case
@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass

def test_init_token_converter(token_converter):
    assert token_converter.canConvert(accounts[0], '2 ether', {'from': accounts[0]}) == True


# def test_token_conversion(token_converter, frame_token, royalty_token):

#     tx1 = royalty_token.setBurnOperator(token_converter, True, {'from': accounts[0]})
#     tx2 = frame_token.setMintOperator(token_converter, True, {'from': accounts[0]})
#     token_converter.convertToken(accounts[0], '15 ethers', {'from': accounts[0]})
#     assert royalty_token.balanceOf(accounts[0]) == '485 ether'
#     assert frame_token.balanceOf(accounts[0]) == '1015 ether'


def test_token_converter_canConvert_no_value(token_converter):
    with reverts():
        token_converter.canConvert(accounts[0], '0', {'from': accounts[0]}) == True

def test_token_converter_canConvert_zero_address(token_converter):
    with reverts():
        token_converter.canConvert(ZERO_ADDRESS, '15 ethers', {'from': accounts[0]}) == True


# def test_token_conversion_not_minter(token_converter, frame_token, royalty_token):
#     user_data = '15 ether converted from regulated to base token'.encode()
#     operator_data = '15 ether converted from regulated to base token'.encode()

#     tx = royalty_token.setBurnOperator(token_converter, True, {'from': accounts[0]})
#     with reverts():
#         token_converter.convertToken(accounts[0],royalty_token, frame_token, '15 ethers', 1, '0x'+user_data.hex(), '0x'+operator_data.hex(), {'from': accounts[0]})

# def test_token_conversion_not_burner(token_converter, frame_token, royalty_token):
#     user_data = '15 ether converted from regulated to base token'.encode()
#     operator_data = '15 ether converted from regulated to base token'.encode()

#     tx = frame_token.setMintOperator(token_converter, True, {'from': accounts[0]})
#     with reverts():
#         token_converter.convertToken(accounts[0],royalty_token, frame_token, '15 ethers', 1, '0x'+user_data.hex(), '0x'+operator_data.hex(), {'from': accounts[0]})

