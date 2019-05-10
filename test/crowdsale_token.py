from util import *
import erc20

symbol = "GRACIE"
name = "Gracie Frame Tokens"
decimals = 18
initial_supply = 20000 * (10 ** 18)
mintable = True
transferable = True


def test(w3, accounts, contract_path, contract_name, btts_library_address):
    owner = accounts[0]
    token_contract = erc20.test(w3, accounts, contract_path, contract_name, name, symbol, decimals,
               initial_supply, owner, mintable, transferable, btts_library_address)
    return token_contract

def get_deployed(w3, accounts, contract_path, contract_name, btts_library_address):
    owner = accounts[0]
    token_contract = test_deploy_library(w3, owner, contract_path, contract_name, btts_library_address,
                                          [owner, symbol, name, decimals, initial_supply, mintable, transferable])
    return token_contract

def set_minter(owner, token_contract, minter):
    tx_hash = transact_function(owner, token_contract, 'setMinter', [minter])
    w3 = token_contract.web3
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    assert tx_receipt['status'] == 1, 'transaction failed'
    set_minter = call_function(token_contract, 'minter')
    assert set_minter == minter, 'minter not set'
    print("SUCCESS: Minter Set: {}".format(set_minter))
