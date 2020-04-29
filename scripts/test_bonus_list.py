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

def test_bonus_list_owned(bonus_list):
    assert bonus_list.owner({'from': accounts[0]}) == accounts[0]

def test_bonus_list_transferOwnership(bonus_list):
    tx = bonus_list.transferOwnership(accounts[2], {'from': accounts[0]})
    tx = bonus_list.acceptOwnership( {'from': accounts[2]})

    assert 'OwnershipTransferred' in tx.events
    assert tx.events['OwnershipTransferred'] == {'from': accounts[0], 'to': accounts[2]}
    with reverts():
        bonus_list.transferOwnership(accounts[2], {'from': accounts[0]})

######################################
# Operated
######################################

def test_bonus_list_addOperator(bonus_list):
    tx = bonus_list.addOperator(accounts[2],{'from': accounts[0]})
    assert 'OperatorAdded' in tx.events



######################################
# BonusList Tests
######################################


def test_bonus_list_add_remove(bonus_list):
    employees = accounts[6]
    tx = bonus_list.add([employees], {'from': accounts[0]})
    assert 'AccountListed' in tx.events
    assert bonus_list.isInWhiteList(accounts[0]) == False
    assert bonus_list.isInWhiteList(accounts[6]) == True
    assert bonus_list.isInWhiteList(accounts[7]) == False

    tx = bonus_list.remove([employees], {'from': accounts[0]})
    assert 'AccountListed' in tx.events
    assert bonus_list.isInWhiteList(accounts[6]) == False

def test_bonus_list_add_none(bonus_list):
    with reverts():
        bonus_list.add([], {'from': accounts[0]})
    with reverts():
        bonus_list.remove([], {'from': accounts[0]})
    with reverts():
        bonus_list.add([ZERO_ADDRESS], {'from': accounts[0]})
    tx = bonus_list.remove([accounts[6]], {'from': accounts[0]})
    assert 'AccountListed' not in tx.events


# def test_bonus_list_add_not_controller(bonus_list):
