from util import test_deploy, call_function, wrong
import random


def test_initialized_correctly(contract, owner):
    print('check that contract is initialized correctly: ', end='')

    got_owner = call_function(contract, 'owner')
    assert got_owner == owner, wrong('owner', got_owner, owner)

    print('SUCCESS')



def test(w3, accounts, contract_path, contract_name):
    owner = accounts[1]
    contract = test_deploy(w3, owner, contract_path, contract_name)
    test_initialized_correctly(contract, owner)
