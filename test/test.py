from web3 import Web3
from web3.middleware import geth_poa_middleware
import subprocess
import os
import sys

import dividend_token
import dream_frame_tokens
import crowdsale_token
import crowdsale_contract
import whitelist
import royalty_crowdsale

from settings import *

from util import test_w3_connected, unlock_and_fund_accounts, test_deploy, print_break, deposit_eth, print_balances, transact_function, call_function
from flatten import flatten_contracts


if __name__ == '__main__':
    #f = open("01_test_output.txt", 'w')
    #sys.stdout = f
    #--------------------------------------------------------------
    # Initialisation
    #--------------------------------------------------------------
    w3 = Web3(Web3.IPCProvider('../testchain/geth.ipc'))
    w3.middleware_stack.inject(geth_poa_middleware, layer=0)
    # w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:7545'))
    # w3 = Web3(Web3.HTTPProvider('http://localhost:8646'))
    test_w3_connected(w3)

    accounts = w3.eth.accounts[:6]
    default_password = ''
    funder = accounts[0]
    owner = accounts[0]
    # Contract variables
    fund_amount = w3.toWei(100, 'ether')
    unlock_and_fund_accounts(w3, accounts, default_password, funder, fund_amount)

    #--------------------------------------------------------------
    # Deploy and test contracts
    #--------------------------------------------------------------
    print_break('Flattening Contracts')
    flatten_contracts()

    print_break('Testing: Whitelist')
    white_list = whitelist.test(w3, accounts, os.path.join(CONTRACT_DIR, WHITELIST_PATH), WHITELIST_NAME, owner, accounts[:3])
    mkr_price = test_deploy(w3, owner, os.path.join(CONTRACT_DIR, MKR_PRICE_PATH), MKR_PRICE_NAME, [0x00000000000000000000000000000000000000000000000942f35e530b9c8000, True])
    price_feed = test_deploy(w3, owner, os.path.join(CONTRACT_DIR, PRICE_FEED_PATH), PRICE_FEED_NAME, [mkr_price.address])

    print_break('Testing: Frame Rush Tokens')
    btts_library_contract = test_deploy(w3, accounts[1], os.path.join(CONTRACT_DIR + BTTS_LIBRARY_PATH), BTTS_LIBRARY_NAME)
    frame_token = crowdsale_token.test(w3, accounts, os.path.join(CONTRACT_DIR, CST_PATH), CST_NAME, btts_library_contract.address)

    print_break('Testing: Dividend Token')
    royalty_token = dividend_token.test(w3, accounts, os.path.join(CONTRACT_DIR, DIVIDEND_TOKEN_PATH), DIVIDEND_TOKEN_NAME, btts_library_contract.address, white_list.address)

    print_break('Testing: Crowdsale Contract')
    frame_token = crowdsale_token.get_deployed(w3, accounts, os.path.join(CONTRACT_DIR, CST_PATH), CST_NAME, btts_library_contract.address)
    royalty_token = dividend_token.get_deployed(w3, accounts, os.path.join(CONTRACT_DIR, DIVIDEND_TOKEN_PATH),DIVIDEND_TOKEN_NAME, btts_library_contract.address, white_list.address)

    crowdsale = crowdsale_contract.test(w3, accounts, os.path.join(CONTRACT_DIR, CSC_PATH), CSC_NAME,frame_token, royalty_token, white_list, price_feed, frame_usd, hard_cap_usd, soft_cap_usd)

    #--------------------------------------------------------------
    # Set contract permissions
    #--------------------------------------------------------------

    crowdsale_token.set_minter(owner, frame_token,crowdsale.address)
    crowdsale_token.set_minter(owner, royalty_token,crowdsale.address)
    print_break('Testing: Deposit ETH to Frames Crowdsale')
    deposit_eth(w3,crowdsale, accounts[1], Web3.toWei(50, "ether"))
    print_balances(frame_token, accounts)
    royalty_crowdsale_contract = royalty_crowdsale.test(w3, accounts, os.path.join(CONTRACT_DIR, RSC_PATH), RSC_NAME,crowdsale.address)

    crowdsale_contract.set_royalty_crowdsale(owner, crowdsale,royalty_crowdsale_contract.address)

    #--------------------------------------------------------------
    # Test crowdsale contracts
    #--------------------------------------------------------------
    # Deposit ETH
    print_break('Testing: Deposit ETH to Royalty Crowdsale')
    deposit_eth(w3,royalty_crowdsale_contract, accounts[2], Web3.toWei(20, "ether"))
    print_break("Royalty Token: {}".format(royalty_token.address))
    print_balances(royalty_token, accounts)
    print_break("FrameRush Token: {}".format(frame_token.address))
    print_balances(frame_token, accounts)

    # AG: Offline purchase
    print_break('Testing: Offline Purchases in USD')
    crowdsale_contract.offline_purchase(owner, crowdsale, accounts[3], 10)
    # AG: Note, fails by design with number > maxFrames
    #crowdsale_contract.offline_purchase(owner, crowdsale, accounts[3], 94302)
    #print_balances(frame_token, accounts)
    #crowdsale_contract.offline_purchase(owner, crowdsale, accounts[3], 1)
    #print_balances(frame_token, accounts)

    # Test overflow of ether and ETH refund
    deposit_eth(w3,crowdsale, accounts[0], Web3.toWei(300, "ether"))
    print_balances(frame_token, accounts)

    frames_remaining = call_function(crowdsale, 'framesRemaining')
    print_break("Frames Remaining: {}".format(frames_remaining))
    #--------------------------------------------------------------
    # Test crowdsale contracts
    #--------------------------------------------------------------
    # Finalise crowdsale
    # AG: Fails if already finalised / tokens fully allocated
    #crowdsale_contract.finalise(owner, crowdsale)
    #royalty_crowdsale.finalise(owner, crowdsale)

    #--------------------------------------------------------------
    # ERC721 Collectables
    #--------------------------------------------------------------
    print_break('Testing: Dream Frame Tokens')
    dream_frame_tokens.test(w3, accounts, os.path.join(CONTRACT_DIR, DFT_PATH), DFT_NAME)

    # Print to file
    #f.close()
