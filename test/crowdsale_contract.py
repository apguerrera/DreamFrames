from web3 import Web3
from util import test_deploy, call_function, wrong, transact, unlock_account, print_balances, transact_function, wait_transaction, print_break

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


def test(w3, accounts, contract_path, contract_name, frame_token, royalty_token, white_list, price_feed, frame_usd, hard_cap_usd, soft_cap_usd):
    owner = accounts[0]
    bonus_list = accounts[5]
    wallet = accounts[5]

    # Deploy contract
    crowdsale_contract = test_deploy(w3, owner, contract_path, contract_name, [frame_token.address, royalty_token.address, price_feed.address, white_list.address, wallet, start_date, end_date, max_frames, frame_usd, bonus_off_list, hard_cap_usd, soft_cap_usd])

    # Tests
    test_initialized_correctly(crowdsale_contract, owner, frame_token.address, royalty_token.address)
    print_balances(frame_token, accounts)
    # Check if hardcap can be reached
    # Check if just under crowdsale, but contributed to be over, see if the difference is calculated and returned, tokens distrubuted
    return crowdsale_contract

def set_royalty_crowdsale(owner, crowdsale_contract, royalty_crowdsale):
    tx_hash = transact_function(owner, crowdsale_contract, 'setRoyaltyCrowdsale', [royalty_crowdsale])
    gas_used = wait_transaction(crowdsale_contract.web3, tx_hash)

    set_crowdsale = call_function(crowdsale_contract, 'royaltyCrowdsaleAddress')
    assert set_crowdsale == royalty_crowdsale, 'royaltyCrowdsaleAddress not set'
    print("SUCCESS: royaltyCrowdsaleAddress Crowdsale set on Frames Crowdsale: {} Gas used: {}".format(set_crowdsale, gas_used))

def set_bonus(owner, contract, new_percent):
    tx_hash = transact_function(owner, contract, 'setBonusOffList', [new_percent])
    gas_used = wait_transaction(contract.web3, tx_hash)

    set_bonus = call_function(contract, 'bonusOffList')
    assert set_bonus == new_percent, 'bonusPercent not set'
    print("SUCCESS: bonusOffList set to: {} Gas used: {}".format(set_bonus, gas_used))


def offline_purchase(owner,crowdsale_contract, account, frames):
    tx_hash = transact_function(owner, crowdsale_contract, 'offlineFramesPurchase', [account, frames])
    gas_used = wait_transaction(crowdsale_contract.web3, tx_hash)
    print("SUCCESS: Offline Frames Purchased: {} Gas used: {}".format(frames, gas_used))

def finalise(owner,crowdsale_contract):
    tx_hash = transact_function(owner, crowdsale_contract, 'finalise')
    gas_used = wait_transaction(crowdsale_contract.web3, tx_hash)
    print("SUCCESS: Crowdsale Finalised. Gas used: {}".format(gas_used))

def print_crowdsale(contract):
    print_break("Crowdsale Contract: {}".format(contract.address))

    print("Frames Remaining: {}".format(call_function(contract, 'framesRemaining')))
    print("pctSold: {}".format(call_function(contract, 'pctSold')))
    print("pctRemaining: {}".format(call_function(contract, 'pctRemaining')))
    print("finalised: {}".format(call_function(contract, 'finalised')))
    print("bonusOffList: {}".format(call_function(contract, 'bonusOffList')))
    print("pctSold: {}".format(call_function(contract, 'pctSold')))
