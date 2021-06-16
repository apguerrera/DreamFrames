from brownie import accounts, web3, Wei, reverts
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract
from settings import *

@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass
######################
# Helper function
#####################

def _claimCollectableToken(frame_rush, frame_token,tokenId, _account):
    _account = _account
    frame_token.approve(accounts[5], 100 * TENPOW18, {'from': accounts[0]})

    frame_token.transferFrom(accounts[0], accounts[3], 100 * TENPOW18, {'from':accounts[5]})
    frame_token.approve(_account, 100 * TENPOW18, {'from': _account})
    frame_token.approve(frame_rush, 100 * TENPOW18, {'from': _account})
    
    
    frame_rush.claimCollectableToken(_account,tokenId, {"from": _account})
    return frame_rush, frame_token

def test_frame_rush_claim(frame_rush,collectable_token, frame_token):
    _account = accounts[3]
    
   # _tokenId = _mint_collectable_token(collectable_token,frame_rush)
    tokenId = 1
    frame_rush, frame_token =  _claimCollectableToken(frame_rush, frame_token,tokenId,_account)

    tokenId = 2
    frame_rush, frame_token =  _claimCollectableToken(frame_rush, frame_token,tokenId,_account)
    
    


def test_is_token_available(frame_rush,collectable_token, frame_token):
    _account = accounts[3]
    
   # _tokenId = _mint_collectable_token(collectable_token,frame_rush)
    tokenId = 1
    frame_rush, frame_token =  _claimCollectableToken(frame_rush, frame_token,tokenId,_account)

    tokenId = 2
    frame_rush, frame_token =  _claimCollectableToken(frame_rush, frame_token,tokenId,_account)

    assert frame_rush.isTokenIdAvailable(2) == False