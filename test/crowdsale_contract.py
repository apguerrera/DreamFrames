from web3 import Web3
from util import test_deploy, call_function, wrong, transact, unlock_account, print_balances, transact_function

# AG - temp account addresses and values
start_date = 12341234456
end_date = 12341238564
max_frames = 94500
#frame_usd = 100 *
bonus_off_list = 40

def test_initialized_correctly(contract, owner, frame_token, royalty_token):
    print('check that contract is initialized correctly: ', end='')
    got_owner = call_function(contract, 'owner')
    assert got_owner == owner, wrong('owner', got_owner, owner)
    print('SUCCESS')


def test(w3, accounts, contract_path, contract_name, frame_token, royalty_token, white_list, price_feed, frame_usd):
    owner = accounts[0]
    bonus_list = accounts[5]
    wallet = accounts[5]

    # Deploy contract
    crowdsale_contract = test_deploy(w3, owner, contract_path, contract_name, [frame_token.address, royalty_token.address, price_feed.address, white_list.address, wallet, start_date, end_date, max_frames, frame_usd, bonus_off_list])

    # Tests
    test_initialized_correctly(crowdsale_contract, owner, frame_token.address, royalty_token.address)
    print_balances(frame_token, accounts)
    # Check if hardcap can be reached
    # Check if just under crowdsale, but contributed to be over, see if the difference is calculated and returned, tokens distrubuted
    return crowdsale_contract

def set_royalty_crowdsale(owner, crowdsale_contract, royalty_crowdsale):
    tx_hash = transact_function(owner, crowdsale_contract, 'setRoyaltyCrowdsale', [royalty_crowdsale])
    w3 = crowdsale_contract.web3
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    assert tx_receipt['status'] == 1, 'transaction failed'
    set_crowdsale = call_function(crowdsale_contract, 'royaltyCrowdsaleAddress')
    assert set_crowdsale == royalty_crowdsale, 'royaltyCrowdsaleAddress not set'
    print("SUCCESS: royaltyCrowdsaleAddress Crowdsale set on Frames Crowdsale: {}".format(set_crowdsale))
