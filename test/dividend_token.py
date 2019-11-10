from web3 import Web3
from util import test_deploy_library, wrong, call_function, transact_function, check_event, reverts, ZERO_ADDRESS, deposit_eth, short_address, wait_transaction, wait_event, print_break
import erc20

name = "Gracie Dividend Tokens"
symbol = "GRACIEDIV"
decimals = 18
initial_supply = 0 * (10 ** decimals)
mintable = True
transferable = True
point_multiplier = 10e32


def get_deployed(w3, accounts, contract_path, contract_name, btts_library_address, white_list):
    owner = accounts[0]
    token_contract = test_deploy_library(w3, owner, contract_path, contract_name, btts_library_address,
                                         [owner, symbol, name, decimals, initial_supply, mintable, transferable, white_list])
    return token_contract


def get_total_dividend_points(contract):
    total_dividend_points = call_function(contract, 'totalDividendPoints')
    return total_dividend_points


def get_unclaimed_dividends(contract):
    unclaimed_dividends = call_function(contract, 'totalUnclaimedDividends')
    return unclaimed_dividends


def get_dividends_owing(contract, account):
    dividends_owing = call_function(contract, 'dividendsOwing', [account])
    return dividends_owing


def get_last_eth_points(contract, account):
    last_eth_points = call_function(contract, 'getLastEthPoints', [account])
    return last_eth_points


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
    print("Dividends for Account: {}".format(account))
    print("getLastEthPoints: {}".format(call_function(contract, 'getLastEthPoints', [account])))
    print("dividendsOwingEth: {}".format(call_function(contract, 'dividendsOwing', [account ])))
    print("unclaimedDividendByAccount: {}".format(call_function(contract, 'unclaimedDividendByAccount', [account])))


def test_initialized_correctly(contract, accounts):
    print('check that contract was initialized correctly: ', end='')

    total_dividend_points = get_total_dividend_points(contract)
    assert total_dividend_points == 0, wrong('total dividends', total_dividend_points, 0)

    unclaimed_dividends = get_unclaimed_dividends(contract)
    assert unclaimed_dividends == 0, wrong('unclaimed dividends', unclaimed_dividends, 0)

    for account in accounts:
        dividend_owings = get_dividends_owing(contract, account)
        assert dividend_owings == 0, wrong(f'dividend owings for {account}', dividend_owings, 0)

    print('SUCCESS')


def check_deposit_dividends(contract, sender, amount):
    unclaimed_dividends = get_unclaimed_dividends(contract)
    total_dividends = get_total_dividend_points(contract)
    dividend_owing = get_dividends_owing(contract, sender)

    total_supply = call_function(contract, 'totalSupply')
    expected_total_dividends = total_dividends + amount * point_multiplier / total_supply

    tx_hash = deposit_eth(contract, sender, amount)

    new_unclaimed_dividends = get_unclaimed_dividends(contract)
    new_total_dividends = float(get_total_dividend_points(contract))

    assert new_unclaimed_dividends == unclaimed_dividends + amount, \
        wrong('unclaimed dividends', new_unclaimed_dividends, unclaimed_dividends + amount)

    assert new_total_dividends == expected_total_dividends, \
        wrong('total dividends', new_total_dividends, expected_total_dividends)

    # TODO: check dividend owings
    # TODO: check unclaimed dividends by account

    check_event(contract, tx_hash, 'DividendReceived', {'sender': sender, 'amount': amount})


def test_deposit_dividends(contract, accounts):
    print('check that dividends are deposited correctly:')

    check_deposit_dividends(contract, accounts[0], 100)
    check_deposit_dividends(contract, accounts[1], 3000)
    check_deposit_dividends(contract, accounts[2], 400)
    check_deposit_dividends(contract, accounts[2], 20)

    print('SUCCESS')


def test(w3, accounts, contract_path, contract_name, btts_library_address, white_list):
    owner = accounts[0]
    token_contract = erc20.test_white_list(w3, accounts, contract_path, contract_name, name, symbol, decimals,
                                           initial_supply, owner, mintable, transferable, btts_library_address,
                                           white_list)

    test_initialized_correctly(token_contract, accounts)
    test_deposit_dividends(token_contract, accounts)

    return token_contract
