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


######################################
# Owned
######################################

def test_token_factory_owned(token_factory):
    assert token_factory.owner({'from': accounts[0]}) == accounts[0]

def test_token_factory_transferOwnership(token_factory):
    tx = token_factory.transferOwnership(accounts[1], {'from': accounts[0]})
    tx = token_factory.acceptOwnership( {'from': accounts[1]})

    assert 'OwnershipTransferred' in tx.events
    assert tx.events['OwnershipTransferred'] == {'from': accounts[0], 'to': accounts[1]}
    with reverts():
        token_factory.transferOwnership(accounts[1], {'from': accounts[0]})


######################################
# Factory Tests
######################################

    assert token_factory.numberOfChildren( {'from': accounts[0]}) == 0