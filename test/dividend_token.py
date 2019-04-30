from util import test_deploy_library, wrong, call_function, transact_function, check_event, reverts, ZERO_ADDRESS
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

    # AG: Issue tokens in different amounts to 3 accounts
    # AG: Test deposit ETH dividends
    # AG: Test claim dividends from each accounts
    # AG: Test if any funds are left
    return token_contract


def get_deployed(w3, accounts, contract_path, contract_name, btts_library_address, white_list):
    owner = accounts[0]
    token_contract = test_deploy_library(w3, owner, contract_path, contract_name, btts_library_address,
                                         [owner, symbol, name, decimals, initial_supply, mintable, transferable, white_list])
    return token_contract
