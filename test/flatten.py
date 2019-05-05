
import subprocess

from settings import *
from util import print_break

def flatten(mainsol, outputsol):
    pipe = subprocess.call("../scripts/solidityFlattener.pl --contractsdir={} --mainsol={} --outputsol={} --verbose"
                           .format(CONTRACT_DIR, mainsol, outputsol), shell=True)
    print(pipe)

def flatten_contracts():
    flatten(WHITELIST_PATH, "../flattened/{}_flattened.sol".format(WHITELIST_NAME))
    flatten(BTTS_LIBRARY_PATH, "../flattened/{}_flattened.sol".format(BTTS_LIBRARY_NAME))
    flatten(PRICE_FEED_PATH, "../flattened/{}_flattened.sol".format(PRICE_FEED_NAME))
    flatten(MKR_PRICE_PATH, "../flattened/{}_flattened.sol".format(MKR_PRICE_NAME))
    flatten(CST_PATH, "../flattened/{}_flattened.sol".format(CST_NAME))
    #flatten(DIVIDEND_TOKEN_PATH, "../flattened/{}_flattened.sol".format(DIVIDEND_TOKEN_NAME))
    flatten(CSC_PATH, "../flattened/{}_flattened.sol".format(CSC_NAME))
    flatten(DFT_PATH, "../flattened/{}_flattened.sol".format(DFT_NAME))
    flatten(RSC_PATH, "../flattened/{}_flattened.sol".format(RSC_NAME))
