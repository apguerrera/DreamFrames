from util import test_deploy_library, wrong, call_function, transact_function, check_event, reverts, ZERO_ADDRESS,\
    deposit_eth, short_address, wait_transaction, wait_event, print_break, get_balance
import erc20
from fractions import Fraction

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


def get_token_balance(contract, account):
    return call_function(contract, 'balanceOf', [account])


def get_total_dividend_points(contract):
    total_dividend_points = call_function(contract, 'totalDividendPoints')
    return total_dividend_points


def get_total_unclaimed_dividends(contract):
    return call_function(contract, 'totalUnclaimedDividends')


def get_unclaimed_dividends(contract):
    unclaimed_dividends = call_function(contract, 'totalUnclaimedDividends')
    return unclaimed_dividends


def get_unclaimed_dividends_by_account(contract, account):
    return call_function(contract, 'unclaimedDividendByAccount', [account])


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
    wait_transaction(contract.web3, tx_hash)


def withdraw_dividends(contract, account):
    tx_hash = transact_function(account, contract, 'withdrawDividends')
    gas_used = wait_transaction(contract.web3, tx_hash)

    return tx_hash, gas_used


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
        dividend_owing = get_dividends_owing(contract, account)
        assert dividend_owing == 0, wrong(f'dividend owing for {account}', dividend_owing, 0)

    print('SUCCESS')


def check_deposit_dividends(contract, account, amount):
    unclaimed_dividends = get_unclaimed_dividends(contract)
    total_dividends = get_total_dividend_points(contract)
    unclaimed_dividends_sender = get_unclaimed_dividends_by_account(contract, account)

    total_supply = call_function(contract, 'totalSupply')
    expected_total_dividends = float(total_dividends + Fraction(int(amount * point_multiplier), total_supply))

    tx_hash = deposit_eth(contract, account, amount)
    check_event(contract, tx_hash, 'DividendReceived', {'sender': account, 'amount': amount})

    new_unclaimed_dividends = get_unclaimed_dividends(contract)
    new_total_dividends = float(get_total_dividend_points(contract))

    assert new_unclaimed_dividends == unclaimed_dividends + amount, \
        wrong('unclaimed dividends', new_unclaimed_dividends, unclaimed_dividends + amount)

    assert new_total_dividends == expected_total_dividends, \
        wrong('total dividends', new_total_dividends, expected_total_dividends)

    last_eth_points = get_last_eth_points(contract, account)
    new_dividend_owing = get_dividends_owing(contract, account)
    balance = get_token_balance(contract, account)

    expected_dividend_owing = int(balance * (new_total_dividends - last_eth_points) / point_multiplier)
    assert new_dividend_owing == expected_dividend_owing, \
        wrong(f'dividend owing for {account}', new_dividend_owing, expected_dividend_owing)

    update_account(contract, account)

    new_unclaimed_dividends_sender = get_unclaimed_dividends_by_account(contract, account)
    expected_unclaimed_dividends_sender = unclaimed_dividends_sender + new_dividend_owing

    assert new_unclaimed_dividends_sender == expected_unclaimed_dividends_sender, \
        wrong(f'unclaimed dividends of {account}', new_unclaimed_dividends_sender, expected_unclaimed_dividends_sender)


def test_deposit_dividends(contract, accounts):
    print('check that dividends are deposited correctly: ', end='')

    check_deposit_dividends(contract, accounts[0], 1000)
    check_deposit_dividends(contract, accounts[1], 600000000)
    check_deposit_dividends(contract, accounts[2], 4000000)
    check_deposit_dividends(contract, accounts[2], 500)

    print('SUCCESS')


def check_withdraw_dividends(contract, account):
    update_account(contract, account)
    unclaimed_dividends = get_unclaimed_dividends_by_account(contract, account)
    total_unclaimed_dividends = get_total_unclaimed_dividends(contract)
    balance = get_balance(contract.web3, account)

    tx_hash, gas_used = withdraw_dividends(contract, account)

    new_unclaimed_dividends = get_unclaimed_dividends_by_account(contract, account)

    assert new_unclaimed_dividends == 0, wrong(f'new unclaimed dividends for {account}', new_unclaimed_dividends, 0)

    new_balance = get_balance(contract.web3, account)
    wei_withdrawn = new_balance - balance

    assert wei_withdrawn == unclaimed_dividends, \
        wrong(f'amount of wei withdrawn by {account}', wei_withdrawn, unclaimed_dividends)

    new_total_unclaimed_dividends = get_total_unclaimed_dividends(contract)
    assert new_total_unclaimed_dividends == total_unclaimed_dividends - unclaimed_dividends, \
        wrong('total unclaimed dividends', new_total_unclaimed_dividends, total_unclaimed_dividends - unclaimed_dividends)

    if unclaimed_dividends > 0:
        check_event(contract, tx_hash, 'WithdrawalDividends', {'holder': account, 'amount': unclaimed_dividends})


def test_withdraw_dividends(contract, accounts):
    print('check that dividends are withdrawn correctly: ', end='')

    check_withdraw_dividends(contract, accounts[0])
    check_withdraw_dividends(contract, accounts[1])
    check_withdraw_dividends(contract, accounts[2])
    check_withdraw_dividends(contract, accounts[2])

    print('SUCCESS')


def test(w3, accounts, contract_path, contract_name, btts_library_address, white_list):
    owner = accounts[0]
    token_contract = erc20.test_white_list(w3, accounts, contract_path, contract_name, name, symbol, decimals,
                                           initial_supply, owner, mintable, transferable, btts_library_address,
                                           white_list)

    test_initialized_correctly(token_contract, accounts)
    test_deposit_dividends(token_contract, accounts)
    test_withdraw_dividends(token_contract, accounts)

    return token_contract
