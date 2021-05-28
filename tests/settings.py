from brownie import accounts, web3, Wei, rpc
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract
import time

ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'
COMPOUND_ORACLE = '0x5722a3f60fa4f0ec5120dcd6c386289a4758d1b2'


FRAME_USD = 100 * (10**18)
ETH_USD = 200 * (10**18)
BONUS = 10
BONUS_ON_LIST = 30 
FRAME_USD_BONUS = int( FRAME_USD * 100 / (100 + BONUS ))
MAX_FRAMES = 100000 
PRODUCER_PCT = 30 
HARDCAP_USD = 30000 * (10**18)
SOFTCAP_USD = 15000 * (10**18)


# Frame Token
FRAME_NAME = 'Dream Frame Token'
FRAME_SYMBOL = 'DFT'

# Royalty Token
ROYALTY_NAME = 'Royalty Token'
ROYALTY_SYMBOL = 'RFT'

# Crowdsale     
CROWDSALE_DAYS = 7 
START_DATE = int(time.time())
END_DATE = START_DATE + 60 * 60 * 24 * CROWDSALE_DAYS


###################################
#Staking
###################################
TENPOW18 = 10 ** 18

ONE_MILLION = 1000000 * TENPOW18
UNISWAP_FACTORY = '0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f'
#######################
# GAZE TOKENS
#######################
GAZE_TOTAL_TOKENS = 29 * ONE_MILLION 

ONE_WEEK = 3600*24*7