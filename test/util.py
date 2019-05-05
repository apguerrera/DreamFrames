import solcx
from os.path import abspath
import subprocess
import re
from web3 import Web3
from eth_abi.exceptions import InsufficientDataBytes
from web3.exceptions import BadFunctionCallOutput

REVERT_MESSAGES = [
    'VM Exception while processing transaction: revert',
    'gas required exceeds allowance or always failing transaction'
]
ZERO_ADDRESS = Web3.toChecksumAddress('0x0000000000000000000000000000000000000000')
SOLC_VERSION = 'v0.5.4'
accounts = []
accountNames = {}

#--------------------------------------------------------------
#  Web3 Connection
#--------------------------------------------------------------

# check that there is connection to ethereum node
def test_w3_connected(w3):
    print('connect to ethereum node: ', end='')
    assert w3.isConnected(), 'not connected to ethereum node'
    print('SUCCESS')


#--------------------------------------------------------------
#  Transactions
#--------------------------------------------------------------

# transact from sender to receiver, amount in wei
def transact(w3, sender, receiver, amount):
    tx_hash = w3.eth.sendTransaction({'from': sender, 'to': receiver, 'value': amount})
    return tx_hash


#--------------------------------------------------------------
#  Account Functions
#--------------------------------------------------------------

def addAccount(account, accountName):
    accounts.append(account)
    accountNames[account] = accountName


# unlock web3 account, set duration to None to remain it unlocked indefinitely
def unlock_account(w3, account, password, duration):
    w3.personal.unlockAccount(account, password, duration)


# unlock every account in list of accounts, fund every account that is not miner
def unlock_and_fund_accounts(w3, accounts, password, miner, amount, duration=None):
    tx_hashes = []
    for account in accounts:
        unlock_account(w3, account, password, duration)
        if w3.eth.getBalance(account) < amount and account != miner:
            tx_hash = transact(w3, miner, account, amount)
            tx_hashes.append(tx_hash)

    for tx_hash in tx_hashes:
        w3.eth.waitForTransactionReceipt(tx_hash)


# decrypt keystore file and return account
def account_from_key(w3, key_path, passphrase):
    with open(key_path) as key_file:
        key_json = key_file.read()
    private_key = w3.eth.account.decrypt(key_json, passphrase)
    account = w3.eth.account.privateKeyToAccount(private_key)
    return account


def deposit_eth(w3,contract, sender, amount):
    print('Deposit crowdsale ETH: ', end='')
    tx_hash = transact(w3, sender, contract.address, amount)
    #print(tx_hash)
    print('SUCCESS: Sent {} ETH to {}'.format(amount, short_address(contract.address)))


#--------------------------------------------------------------
#  Deployment
#--------------------------------------------------------------

# test that contract is deployed correctly
def test_deploy(w3, account, path, name, args=()):
    print('{}: deploy contract with args: {}: '.format(name, prettify_args(args)), end='')

    contract, gas_used = deploy_contract(w3, account, path, name, args)
    assert w3.isAddress(contract.address), 'failed to deploy contract'

    print('contract deployed at address: {}: gas used: {}: SUCCESS'.format(short_address(contract.address), gas_used))
    return contract


# test that contract is deployed correctly
def test_deploy_library(w3, account, path, name, library, args=()):
    print('{}: deploy contract with args: {}: '.format(name, prettify_args(args)), end='')

    contract, gas_used = deploy_contract_library(w3, account, path, name, library, args)
    assert w3.isAddress(contract.address), 'failed to deploy contract'

    print('contract deployed at address: {}: gas used: {}: SUCCESS'.format(short_address(contract.address), gas_used))
    return contract


def replace_library(bytecode, lib_address):
    if '_' in bytecode:
        # find and replace unlinked library pointers in bytecode
        for marker in re.findall('_{1,}[^_]*_{1,}', bytecode):
            bytecode = bytecode.replace(marker, lib_address[-40:])
    return bytecode


# test that contract can't be deployed correctly
def test_deploy_fail(w3, account, path, name, args=()):
    print('{}: contract should not be deployed with args: {}: '.format(name, prettify_args(args)), end='')
    assert reverts(deploy_contract, [w3, account, path, name, args]), 'contract should not be deployed'
    print('deploy transaction reverted: SUCCESS')


# check if function reverts
def reverts(func, args=()):
    try:
        func(*args)
    except ValueError as e:
        # reverts on transact
        if type(e.args[0]) == dict and e.args[0].get('message', None) in REVERT_MESSAGES:
            return True
        else:
            raise e
    # reverts on call
    except InsufficientDataBytes and BadFunctionCallOutput:
        return True

    return False


#--------------------------------------------------------------
#  Contracts
#--------------------------------------------------------------

# compile contract using solcx and return contract interface
def compile_contract(path, name, contract_root):
    solcx.set_solc_version(SOLC_VERSION)
    compiled_contacts = solcx.compile_files([path], allow_paths=abspath(contract_root), optimize=True)
    contract_interface = compiled_contacts['{}:{}'.format(path, name)]
    return contract_interface


# compile contract, deploy it from account specified, then return transaction hash and contract interface
def deploy_contract(w3, account, path, name, args=(), contract_root='../contracts/'):
    contract_interface = compile_contract(path, name, contract_root)
    contract = w3.eth.contract(abi=contract_interface['abi'], bytecode=contract_interface['bin'])
    tx_hash = contract.constructor(*args).transact({'from': account})
    contract_address, gas_used = wait_contract_info(w3, tx_hash)
    if contract_address is None:
        raise Exception('Failed to deploy: {}'.format(name))
    return get_contract(w3, contract_address, contract_interface['abi']), gas_used


# compile contract, deploy it from account specified, then return transaction hash and contract interface
def deploy_contract_library(w3, account, path, name, library_address, args=(), contract_root='../contracts/'):
    contract_interface = compile_contract(path, name, contract_root)
    contract_bytecode = replace_library(contract_interface['bin'], library_address)
    contract = w3.eth.contract(abi=contract_interface['abi'], bytecode=contract_bytecode)
    tx_hash = contract.constructor(*args).transact({'from': account})
    contract_address, gas_used = wait_contract_info(w3, tx_hash)
    if contract_address is None:
        raise Exception('Failed to deploy: {}'.format(name))
    return get_contract(w3, contract_address, contract_interface['abi']), gas_used


# return address of fresh created contract using hash returned from deploy_contract
# return None if transaction was not included to block
def created_contract_info(w3, tx_hash):
    tx_receipt = w3.eth.getTransactionReceipt(tx_hash)
    if tx_receipt is None or tx_receipt['status'] != 1:
        return None
    return tx_receipt['contractAddress'], tx_receipt['gasUsed']


# wait for deploy transaction to be included to block, return address of created contract
def wait_contract_info(w3, tx_hash):
    w3.eth.waitForTransactionReceipt(tx_hash)
    return created_contract_info(w3, tx_hash)

# return contract object using its address and ABI
def get_contract(w3, address, abi):
    return w3.eth.contract(address=address, abi=abi)

#--------------------------------------------------------------
#  Contract Calls
#--------------------------------------------------------------

# make transaction to contract invoking function, return transaction hash
def transact_function(account, contract, function_name, args=()):
    tx_hash = contract.functions[function_name](*args).transact({'from': account})
    return tx_hash.hex()


# make call to contract function, return the result of call
def call_function(contract, function_name, args=(), account=None):
    if account is None:
        account = contract.web3.eth.accounts[-1]
    return contract.functions[function_name](*args).call({'from': account})

def wait_transaction(w3, tx_hash):
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    assert tx_receipt['status'] == 1, 'transaction failed'
    return tx_receipt['gasUsed']

#--------------------------------------------------------------
#  Events
#--------------------------------------------------------------

# return event data from transaction with hash tx_hash
# return None if transaction was not included to block
def get_event(contract, tx_hash, event_name):
    tx_receipt = contract.web3.eth.getTransactionReceipt(tx_hash)
    if not tx_receipt:
        return None
    return contract.events[event_name]().processReceipt(tx_receipt)


# wait for transaction to be included to block, return event data
def wait_event(contract, tx_hash, event_name):
    contract.web3.eth.waitForTransactionReceipt(tx_hash)
    return get_event(contract, tx_hash, event_name)

# check that event is emitted correctly
def check_event(contract, tx_hash, event, expected_response=None):
    if expected_response is None:
        expected_response = {}
    events = wait_event(contract, tx_hash, event)
    assert len(events) == 1, wrong('number of {} events emitted'.format(event), len(events), 1)

    if expected_response is not None:
        args = events[0]['args']
        for key in expected_response:
            assert expected_response.get(key, None) is not None, 'no "{}" field in event args'.format(key)
            expected = expected_response[key]
            assert args[key] == expected, wrong('"{}" field in {} event'.format(key, event), args[key], expected)


#--------------------------------------------------------------
#  Terminal Functions
#--------------------------------------------------------------

# run command in terminal
def run_cmd(command):
    return subprocess.run(command, shell=True, stderr=subprocess.PIPE)


#--------------------------------------------------------------
#  Display / Print Functions
#--------------------------------------------------------------

# make address shorter, e.g 0x66bc8ccB23271187a13B9e41572aA0e749cf905B => 0x66bc...905B
def short_address(address):
    return '{}...{}'.format(address[:6], address[-4:])


# make all addresses shorter recursively, possible to add more formatting features
def prettify_args(args):
    res = []
    for arg in args:
        if type(arg) == list or type(arg) == tuple:
            res.append(prettify_args(arg))
        elif Web3.isAddress(arg):
            res.append('{}...{}'.format(arg[:6], arg[-4:]))
        else:
            res.append(arg)
    return res

# Error return
def wrong(subject, got, expected):
    return 'wrong {}, expected: {}, got: {}'.format(subject, expected, got)

# print message headers for terminal output
def print_break(msgToPrint):
    print('-' * 30)
    print(msgToPrint)
    print('-' * 30)

# print balances of a set token
def print_balances(token, accounts):
    decimals = call_function(token, 'decimals')  # AG: replace with token.decimals()
    i = 0
    totalTokenBalance = 0
    w3 = token.web3
    baseBlock = w3.eth.blockNumber
    addAccount(w3.eth.accounts[0], "Account #0 - Miner")
    addAccount(w3.eth.accounts[1], "Account #1 - Owner")
    addAccount(w3.eth.accounts[2], "Account #2 - Alice")
    addAccount(w3.eth.accounts[3], "Account #3 - Bob")
    addAccount(w3.eth.accounts[4], "Account #4 - Carol")
    addAccount(w3.eth.accounts[5], "Account #5 - Dave")
    print(" # Account                                                EtherBalance       EtherBalanceChange                   Token Name")
    print("-- ------------------------------------------ ------------------------ ------------------------ ----------------------- ---------------------")

    while (i < len(accounts)):
        etherBalanceBaseBlock = w3.eth.getBalance(accounts[i], baseBlock)
        # etherBalanceBaseBlock = w3.eth.getBalance(accounts[i], baseBlock)
        etherDifference = w3.fromWei((w3.eth.getBalance(accounts[i]) - etherBalanceBaseBlock), "ether")

        etherBalance = w3.fromWei(w3.eth.getBalance(accounts[i]), "ether")
        if etherBalance > 100000000:
            etherBalance = 100000000
        if token == "":
            tokenBalance = 0
        else:
            tokenBalance = call_function(token, 'balanceOf', [accounts[i]]) / (10 ** decimals)

            #tokenBalance = token.balanceOf(accounts[i]).shift(-decimals)
        totalTokenBalance = totalTokenBalance + tokenBalance
        print("" + pad2(i) + " " + accounts[i]  +  " " + pad(etherBalance) + " " + pad(etherDifference) + " " + padToken(tokenBalance, decimals) + " " + accountNames[accounts[i]])
        i = i + 1

    print("-- ------------------------------------------ ------------------------ ------------------------- ---------------------")
    print("                                                                         " + padToken(totalTokenBalance, decimals) + " Total Token Balances")
    print("-- ------------------------------------------ ------------------------ ------------------------- ---------------------")
    print("")

def pad2(s):
    o = str(s)
    while(len(o) < 2):
        o = " " + o
    return o

def pad(s):
    o = str(s)
    while(len(o) < 24):
        o = " " + o
    return o

def padToken(s, decimals):
    o = str(s)
    l = decimals + 5
    while(len(o) < l):
        o = " " + o
    return o
