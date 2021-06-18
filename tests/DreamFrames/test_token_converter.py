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


def test_token_conversion(token_converter, white_list, frame_token, royalty_token):
    white_list.add([accounts[0]],{'from': accounts[0]})
    frame_token.approve(token_converter,'15 ethers',{'from': accounts[0]})
    token_converter.convertRoyaltyToken('15 ethers', {'from': accounts[0]})
    assert frame_token.balanceOf(accounts[0]) == '985 ether'
    assert royalty_token.balanceOf(accounts[0]) == '515 ether'

def test_token_convert_approveAndCall(token_converter, white_list, frame_token, royalty_token):
    white_list.add([accounts[0]],{'from': accounts[0]})
    user_data = ''.encode()

    frame_token.approveAndCall(token_converter, '15 ethers', '0x'+user_data.hex(), {'from': accounts[0]} )
    assert frame_token.balanceOf(accounts[0]) == '985 ether'
    assert royalty_token.balanceOf(accounts[0]) == '515 ether'

def test_token_converter_canConvert_no_value(token_converter):
    assert token_converter.canConvert(accounts[0], 0, {'from': accounts[0]}) == False

def test_token_converter_canConvert_zero_address(token_converter):
    assert token_converter.canConvert(ZERO_ADDRESS, '15 ethers', {'from': accounts[0]}) == False

def test_token_converter_setConvertable(token_converter):
    token_converter.setConvertable(False, {'from': accounts[0]})
    assert token_converter.canConvert(accounts[0], '2 ether', {'from': accounts[0]}) == False

def test_token_converter_setMintable(token_converter, royalty_token):
    tx = royalty_token.setMinter(accounts[2],{'from': accounts[0]})
    assert 'MinterUpdated' in tx.events
    tx = royalty_token.disableMinting({'from': accounts[2]})
    assert 'MintingDisabled' in tx.events
    assert royalty_token.mintable() == False
    assert token_converter.canConvert(accounts[0], '2 ether', {'from': accounts[0]}) == False
