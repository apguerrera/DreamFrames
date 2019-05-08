from web3 import Web3
from web3.middleware import geth_poa_middleware
import subprocess
import os
import sys


import dividend_token
import dividend_token_multi
import dream_frame_tokens
import crowdsale_token
import crowdsale_contract
import whitelist
import royalty_crowdsale
import erc20

from settings import *

from util import test_w3_connected, unlock_and_fund_accounts, test_deploy, print_break, ZERO_ADDRESS, deposit_eth, print_balances, transact_function, call_function
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
    fund_amount = w3.toWei(1000, 'ether')
    unlock_and_fund_accounts(w3, accounts, default_password, funder, fund_amount)

    #--------------------------------------------------------------
    # Deploy and test contracts
    #--------------------------------------------------------------
    print_break('Flattening Contracts')
    flatten_contracts()

    print_break('Testing: Whitelist')
    white_list = whitelist.test(w3, accounts, os.path.join(CONTRACT_DIR, WHITELIST_PATH), WHITELIST_NAME, owner, accounts[:4])
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
    deposit_eth(w3,crowdsale, accounts[1], Web3.toWei(500, "ether"))
    print_balances(frame_token, accounts)
    royalty_crowdsale_contract = royalty_crowdsale.test(w3, accounts, os.path.join(CONTRACT_DIR, RSC_PATH), RSC_NAME,crowdsale.address)

    crowdsale_contract.set_royalty_crowdsale(owner, crowdsale,royalty_crowdsale_contract.address)

    #--------------------------------------------------------------
    # Test crowdsale contracts
    #--------------------------------------------------------------
    # Deposit ETH
    print_break('Testing: Deposit ETH to Royalty Crowdsale')
    deposit_eth(w3,royalty_crowdsale_contract, accounts[2], Web3.toWei(200, "ether"))
    #deposit_eth(w3,royalty_crowdsale_contract, accounts[1], Web3.toWei(200, "ether"))
    print_break("Royalty Token: {}".format(royalty_token.address))
    print_balances(royalty_token, accounts)
    print_break("FrameRush Token: {}".format(frame_token.address))
    print_balances(frame_token, accounts)
    crowdsale_contract.print_crowdsale(crowdsale)

    # Offline purchase
    print_break('Testing: Offline Purchases in USD')
    crowdsale_contract.offline_purchase(owner, crowdsale, accounts[3], 10000)

    # Change bonusOffList
    crowdsale_contract.set_bonus(owner, crowdsale, 20)

    crowdsale_contract.offline_purchase(owner, crowdsale, accounts[4], 20000)
    # AG: Note, fails by design with number > maxFrames
    #crowdsale_contract.offline_purchase(owner, crowdsale, accounts[3], 94302)
    #print_balances(frame_token, accounts)
    #crowdsale_contract.offline_purchase(owner, crowdsale, accounts[3], 1)
    #print_balances(frame_token, accounts)

    # Test overflow of ether and ETH refund
    deposit_eth(w3,crowdsale, accounts[2], Web3.toWei(200, "ether"))

    deposit_eth(w3,crowdsale, accounts[0], Web3.toWei(30000, "ether"))
    print_balances(frame_token, accounts)

    crowdsale_contract.print_crowdsale(crowdsale)
    #--------------------------------------------------------------
    # Test royalty crowdsale contracts
    #--------------------------------------------------------------
    # Finalise crowdsale
    # AG: Fails if already finalised / tokens fully allocated
    #crowdsale_contract.finalise(owner, crowdsale)
    #royalty_crowdsale.finalise(owner, crowdsale)

    #--------------------------------------------------------------
    # Test dividends
    #--------------------------------------------------------------
    print_break('Testing: Dividend Payments')
    # AG: Deposit ETH into Royalty contract
    dividend_token.get_unclaimed_dividends(royalty_token)
    dividend_token.get_total_dividend_points(royalty_token)
    deposit_eth(w3,royalty_token, accounts[0], Web3.toWei(30000, "ether"))
    dividend_token.get_unclaimed_dividends(royalty_token)
    dividend_token.get_total_dividend_points(royalty_token)
    dividend_token.get_dividends_owing(royalty_token, accounts[2])
    dividend_token.get_last_eth_points(royalty_token, accounts[2])
    # AG: Get contract balance working - Check examples
    #etherBalance = w3.fromWei(w3.eth.getBalance(royalty_token.address), "ether")
    #print('Royalty Contract ETH Balance: {}'.format(etherBalance))

    # AG: Transfer tokens
    # Unlock transfers for account
    dividend_token.unlock_account(owner, royalty_token, accounts[2])
    #dividend_token.unlock_account(owner, royalty_token, accounts[1])
    print_balances(royalty_token, accounts)

    erc20.check_transfer(royalty_token, accounts[2], accounts[3], 200 * (10 ** decimals))
    print_balances(royalty_token, accounts)
    print_break('Testing: Dividends After Transfers')

    # AG: Claim dividends from each accounts
    dividend_token.print_dividend_contract(royalty_token)
    dividend_token.get_unclaimed_dividends(royalty_token)
    dividend_token.update_account(royalty_token, accounts[2])
    dividend_token.update_account(royalty_token, accounts[3])
    dividend_token.print_dividend_account(royalty_token, accounts[2])
    dividend_token.print_dividend_account(royalty_token, accounts[3])

    deposit_eth(w3,royalty_token, accounts[0], Web3.toWei(20000, "ether"))
    dividend_token.update_account(royalty_token, accounts[2])
    dividend_token.update_account(royalty_token, accounts[3])
    dividend_token.print_dividend_account(royalty_token, accounts[2])
    dividend_token.print_dividend_account(royalty_token, accounts[3])
    print_break('Testing: Dividends After Multiple One Way Transfers')

    erc20.check_transfer(royalty_token, accounts[2], accounts[1], 20 * (10 ** decimals))
    dividend_token.print_dividend_account(royalty_token, accounts[1])
    dividend_token.print_dividend_account(royalty_token, accounts[2])
    dividend_token.print_dividend_account(royalty_token, accounts[3])
    erc20.check_transfer(royalty_token, accounts[2], accounts[1], 20 * (10 ** decimals))
    dividend_token.print_dividend_account(royalty_token, accounts[1])
    dividend_token.print_dividend_account(royalty_token, accounts[2])
    dividend_token.print_dividend_account(royalty_token, accounts[3])
    erc20.check_transfer(royalty_token, accounts[2], accounts[1], 40 * (10 ** decimals))
    erc20.check_transfer(royalty_token, accounts[1], accounts[3], 20 * (10 ** decimals))
    dividend_token.print_dividend_account(royalty_token, accounts[1])
    dividend_token.print_dividend_account(royalty_token, accounts[2])
    dividend_token.print_dividend_account(royalty_token, accounts[3])


    print_break('Testing: Withdraw Dividends')
    #dividend_token.withdraw_dividends(royalty_token, accounts[3])
    #dividend_token.withdraw_dividends(royalty_token, accounts[2])
    dividend_token.print_dividend_account(royalty_token, accounts[1])
    dividend_token.print_dividend_account(royalty_token, accounts[2])
    dividend_token.print_dividend_account(royalty_token, accounts[3])
    deposit_eth(w3,royalty_token, accounts[0], Web3.toWei(20000, "ether"))
    erc20.check_transfer(royalty_token, accounts[2], accounts[3], 30 * (10 ** decimals))
    deposit_eth(w3,royalty_token, accounts[0], Web3.toWei(10000, "ether"))
    dividend_token.update_account(royalty_token, accounts[1])
    dividend_token.update_account(royalty_token, accounts[2])
    dividend_token.update_account(royalty_token, accounts[3])
    dividend_token.print_dividend_account(royalty_token, accounts[1])
    dividend_token.print_dividend_account(royalty_token, accounts[2])
    dividend_token.print_dividend_account(royalty_token, accounts[3])
    dividend_token.get_unclaimed_dividends(royalty_token)
    dividend_token.get_total_dividend_points(royalty_token)
    dividend_token.withdraw_dividends(royalty_token, accounts[1])
    dividend_token.withdraw_dividends(royalty_token, accounts[2])
    dividend_token.withdraw_dividends(royalty_token, accounts[3])
    dividend_token.print_dividend_account(royalty_token, accounts[1])
    dividend_token.print_dividend_account(royalty_token, accounts[2])
    dividend_token.print_dividend_account(royalty_token, accounts[3])
    dividend_token.get_unclaimed_dividends(royalty_token)
    dividend_token.get_total_dividend_points(royalty_token)

    # AG: Test if any funds are left
    print_balances(royalty_token, accounts)
    #--------------------------------------------------------------
    # ERC721 Collectables
    #--------------------------------------------------------------
    print_break('Testing: Dream Frame Tokens')
    dream_frame_tokens.test(w3, accounts, os.path.join(CONTRACT_DIR, DFT_PATH), DFT_NAME)

    # Print to file
    #f.close()
