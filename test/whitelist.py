from util import test_deploy, call_function, wrong, prettify_args, transact_function, get_event
import random


def test_initialized_correctly(contract, owner):
    print('check that contract is initialized correctly: ', end='')

    got_owner = call_function(contract, 'owner')
    assert got_owner == owner, wrong('owner', got_owner, owner)

    print('SUCCESS')


# test that addresses are added correctly to WhiteList
def test_add_to_whitelist(w3, owner, whitelist_contract, addresses):
    print('add addresses: {}: to whitelist at address: {}: '
          .format(prettify_args(addresses), whitelist_contract.address), end='')

    tx_hash = transact_function(owner, whitelist_contract, 'add', [addresses])
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    assert tx_receipt['status'] == 1, 'transaction failed'

    events = get_event(whitelist_contract, tx_hash, 'AccountListed')
    event_args = [events[i]['args'] for i in range(len(events))]

    accounts = [event_arg['account'] for event_arg in event_args]
    assert sorted(accounts) == sorted(addresses), \
        'wrong accounts listed in events, should be: {}, got: {}'.format(sorted(addresses), sorted(accounts))

    for event_arg in event_args:
        assert event_arg['status'] == True, 'wrong status, should be: {}, got: {}'.format(False, event_arg['status'])
        in_whitelist = call_function(whitelist_contract, 'isInWhiteList', [event_arg['account']])
        assert in_whitelist, 'address not added to whitelist: {}'.format(event_arg['account'])

    print('gas used: {}: SUCCESS'.format(tx_receipt['gasUsed']))



def test(w3, accounts, contract_path, contract_name, owner, whitelist_accounts):

    contract = test_deploy(w3, owner, contract_path, contract_name)
    test_initialized_correctly(contract, owner)
    test_add_to_whitelist(w3, owner, contract, whitelist_accounts)
    return contract
