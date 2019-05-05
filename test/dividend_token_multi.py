
from web3 import Web3
from util import test_deploy_library, wrong, call_function, transact_function, check_event, reverts, ZERO_ADDRESS, deposit_eth, short_address, wait_transaction, wait_event, print_break
import erc20

name = "Gracie Dividend Tokens"
symbol = "GRACIEDIV"
decimals = 18
initial_supply = 0 * (10 ** decimals)
mintable = True
transferable = True

def test(w3, accounts, contract_path, contract_name, btts_library_address, white_list):
    owner = accounts[0]
    token_contract = erc20.test_white_list(w3, accounts, contract_path, contract_name, name, symbol, decimals,
               initial_supply, owner, mintable, transferable, btts_library_address, white_list)
    return token_contract


def get_deployed(w3, accounts, contract_path, contract_name, btts_library_address, white_list):
    owner = accounts[0]
    token_contract = test_deploy_library(w3, owner, contract_path, contract_name, btts_library_address,
                                         [owner, symbol, name, decimals, initial_supply, mintable, transferable, white_list])
    return token_contract

def get_total_dividend_points(contract):
    total_dividend_points = call_function(contract, 'totalDividendPoints', [ZERO_ADDRESS])
    print("Total Dividend Points: {}".format(total_dividend_points))

def get_unclaimed_dividends(contract):
    unclaimed_dividends = call_function(contract, 'totalUnclaimedDividends', [ZERO_ADDRESS])
    print("Total Unclaimed Dividends: {}".format(unclaimed_dividends))

def get_dividends_owing(contract, account):
    dividends_owing = call_function(contract, 'dividendsOwing', [account, ZERO_ADDRESS])
    print("Dividends owed for {}: {}".format(short_address(account), dividends_owing))

def get_last_eth_points(contract, account):
    last_eth_points = call_function(contract, 'getLastEthPoints', [account])
    print("Last Eth Points for {}: {}".format(short_address(account), last_eth_points))

def unlock_account(owner, contract, account):
    tx_hash = transact_function(owner, contract, 'unlockAccount', [account])
    gas_used = wait_transaction(contract.web3, tx_hash)
    print("SUCCESS: Account Unlocked: {} Gas used: {}".format(short_address(account), gas_used))


def update_account(contract, account):
    tx_hash = transact_function(account, contract, 'updateAccount', [account])
    gas_used = wait_transaction(contract.web3, tx_hash)
    print("SUCCESS: Account Updated: {} Gas used: {}".format(short_address(account), gas_used))


def withdraw_dividends(contract, account):
    tx_hash = transact_function(account, contract, 'withdrawDividends')
    withdraw_event =  wait_event(contract, tx_hash, 'WithdrawalDividends')

    print("SUCCESS: Withdrew Dividends: {} Event: {}".format(short_address(account), withdraw_event))

def print_dividend_contract(contract):
    print_break("Dividend Contract: {}".format(contract.address))
    print("Symbol: {}".format(call_function(contract, 'symbol')))
    print("Name: {}".format(call_function(contract, 'name')))

def print_dividend_account(contract, account):
    print_break("Dividend for Account: {}".format(account))
    print("getLastEthPoints: {}".format(call_function(contract, 'getLastEthPoints', [account])))
    print("dividendsOwingEth: {}".format(call_function(contract, 'dividendsOwing', [account,ZERO_ADDRESS ])))
    print("unclaimedDividendByAccount: {}".format(call_function(contract, 'unclaimedDividendByAccount', [account,ZERO_ADDRESS ])))
