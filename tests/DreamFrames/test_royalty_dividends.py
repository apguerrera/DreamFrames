from brownie import accounts, web3, Wei, reverts
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract

ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'
TOTAL_SUPPLY = 500 * 10 ** 18

# reset the chain after every test case
@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_init_royalty_dividend(royalty_token):
    assert royalty_token.name() == 'Royalty Token'
    assert royalty_token.symbol() == 'RFT'
    assert royalty_token.totalSupply() == TOTAL_SUPPLY
    assert royalty_token.balanceOf(accounts[0]) == TOTAL_SUPPLY
