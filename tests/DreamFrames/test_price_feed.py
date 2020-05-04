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

def test_price_simulator_owned(price_simulator):
    assert price_simulator.owner({'from': accounts[0]}) == accounts[0]

def test_price_simulator_transferOwnership(price_simulator):
    tx = price_simulator.transferOwnership(accounts[1], {'from': accounts[0]})
    tx = price_simulator.acceptOwnership( {'from': accounts[1]})

    assert 'OwnershipTransferred' in tx.events
    assert tx.events['OwnershipTransferred'] == {'from': accounts[0], 'to': accounts[1]}
    with reverts():
        price_simulator.transferOwnership(accounts[1], {'from': accounts[0]})

