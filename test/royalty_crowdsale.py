from web3 import Web3
from util import test_deploy, call_function, wrong, transact, unlock_account, print_balances, transact_function


def test_initialized_correctly(contract, owner):
    print('check that contract is initialized correctly: ', end='')
    got_owner = call_function(contract, 'owner')
    assert got_owner == owner, wrong('owner', got_owner, owner)
    print('SUCCESS')


def test(w3, accounts, contract_path, contract_name, crowdsale, max_royalty_frames):

    crowdsale_contract = deploy(w3, accounts, contract_path, contract_name, crowdsale, max_royalty_frames)
    owner = call_function(crowdsale_contract, 'owner')
    test_initialized_correctly(crowdsale_contract, owner)
    # AG: Test if frame tokens are generated correctly
    # AG: Test hardcap limit

    return crowdsale_contract

def deploy(w3, accounts, contract_path, contract_name, crowdsale, max_royalty_frames):
    owner = accounts[0]
    wallet = accounts[4]
    crowdsale_contract = test_deploy(w3, owner, contract_path, contract_name, [wallet, crowdsale, max_royalty_frames])
    return crowdsale_contract


def set_frames_crowdsale(owner, royalty_crowdsale_contract, crowdsale):
    tx_hash = transact_function(owner, royalty_crowdsale_contract, 'setFrameCrowdsaleContract', [crowdsale])
    w3 = royalty_crowdsale_contract.web3
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    assert tx_receipt['status'] == 1, 'transaction failed'
    set_crowdsale = call_function(royalty_crowdsale_contract, 'crowdsaleContract')
    assert set_crowdsale == crowdsale, 'crowdsaleContract not set'
    print("SUCCESS: Frames Crowdsale set on Royalty Crowdsale: {}".format(set_crowdsale))
