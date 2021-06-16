from brownie import accounts, web3, Wei, reverts
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract
from settings import *

@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass

def test_frame_rush_claim(frame_rush,collectable_token, frame_token):
    _account = accounts[3]
    
   # _tokenId = _mint_collectable_token(collectable_token,frame_rush)
    
    frame_token.approve(accounts[5], 100 * TENPOW18, {'from': accounts[0]})

    frame_token.transferFrom(accounts[0], accounts[3], 100 * TENPOW18, {'from':accounts[5]})
    frame_token.approve(accounts[3], 100 * TENPOW18, {'from': accounts[3]})
    frame_token.approve(frame_rush, 100 * TENPOW18, {'from': accounts[3]})
    
    
    frame_rush.claimCollectableToken(accounts[3], {"from": accounts[3]}).call_trace
    

""" def _mint_collectable_token(collectable_token,frame_rush):
    tokenid = collectable_token.mint(accounts[0],{"from": accounts[0]}).return_value
    collectable_token.approve(frame_rush, tokenid,{"from":accounts[0]})
    return tokenid """