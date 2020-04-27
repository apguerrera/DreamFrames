from brownie import accounts, web3, Wei, reverts
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract

ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'
TOTAL_SUPPLY = 500 * 10 ** 18

# reset the chain after every test case
@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_init_royalty_token(royalty_token):
    assert royalty_token.name() == 'Royalty Token'
    assert royalty_token.symbol() == 'RFT'
    assert royalty_token.totalSupply() == TOTAL_SUPPLY
    assert royalty_token.balanceOf(accounts[0]) == TOTAL_SUPPLY

######################################
# Owned
######################################

def test_royalty_token_owned(royalty_token):
    assert royalty_token.owner({'from': accounts[0]}) == accounts[0]

def test_royalty_token_transferOwnership(royalty_token):
    tx = royalty_token.transferOwnership(accounts[2], {'from': accounts[0]})
    tx = royalty_token.acceptOwnership( {'from': accounts[2]})

    assert 'OwnershipTransferred' in tx.events
    assert tx.events['OwnershipTransferred'] == {'from': accounts[0], 'to': accounts[2]}
    with reverts():
        royalty_token.transferOwnership(accounts[2], {'from': accounts[0]})

######################################
# ERC20 Tests
######################################

def test_erc20_transfer(royalty_token, white_list):
    white_list.add([accounts[2]],{'from': accounts[0]})
    tx = royalty_token.transfer(accounts[2], '2 ether', {'from': accounts[0]})

    assert royalty_token.balanceOf(accounts[0]) == TOTAL_SUPPLY - 2 * 10**18
    assert royalty_token.balanceOf(accounts[2]) == '2 ether'

    assert 'Transfer' in tx.events
    assert tx.events['Transfer'] == {'from': accounts[0], 'to': accounts[2], 'tokens': '2 ether'}


def test_erc20_transfer_not_enough_funds(royalty_token):
    with reverts():
        royalty_token.transfer(accounts[2], '1001 ether', {'from': accounts[0]})


def test_erc20_approve(royalty_token):
    tx = royalty_token.approve(accounts[2], '5 ether', {'from': accounts[0]})

    assert royalty_token.allowance(accounts[0], accounts[2]) == '5 ether'

    assert 'Approval' in tx.events
    assert tx.events['Approval'] == {'tokenOwner': accounts[0], 'spender': accounts[2], 'tokens': '5 ether'}


def test_erc20_transfer_from(royalty_token, white_list):
    white_list.add([accounts[3]],{'from': accounts[0]})
    royalty_token.approve(accounts[2], '10 ether', {'from': accounts[0]})

    tx = royalty_token.transferFrom(accounts[0], accounts[3], '5 ether', {'from': accounts[2]})

    assert royalty_token.balanceOf(accounts[0]) == TOTAL_SUPPLY - 5 * 10**18
    assert royalty_token.balanceOf(accounts[3]) == '5 ether'

    assert 'Transfer' in tx.events
    assert tx.events['Transfer'] == {'from': accounts[0], 'to': accounts[3], 'tokens': '5 ether'}


def test_erc20_transfer_from_not_enough_funds(royalty_token):
    royalty_token.approve(accounts[2], TOTAL_SUPPLY+1 , {'from': accounts[0]})
    with reverts():
        royalty_token.transferFrom(accounts[0], accounts[3], TOTAL_SUPPLY +1, {'from': accounts[2]})



######################################
# Minting and management
######################################


def test_btts_minter(royalty_token):
    tx = royalty_token.setMinter(accounts[2],{'from': accounts[0]})
    assert 'MinterUpdated' in tx.events

    tx = royalty_token.setMinter(accounts[3],{'from': accounts[0]})
    assert 'MinterUpdated' in tx.events
    assert tx.events['MinterUpdated'] == {'from': accounts[2], 'to': accounts[3]}


def test_btts_disableMinting(royalty_token, white_list):
    tx = royalty_token.setMinter(accounts[2],{'from': accounts[0]})
    assert 'MinterUpdated' in tx.events
    white_list.add([accounts[3],],{'from': accounts[0]})
 
    tx = royalty_token.mint(accounts[3], '5 ether', False, {'from': accounts[0]})
    assert royalty_token.balanceOf(accounts[3]) == '5 ether'

    tx = royalty_token.disableMinting({'from': accounts[2]})
    assert 'MintingDisabled' in tx.events
    assert royalty_token.mintable() == False

    with reverts():
        tx = royalty_token.mint(accounts[3], '5 ether', False, {'from': accounts[0]})

    assert royalty_token.balanceOf(accounts[3]) == '5 ether'


