from brownie import accounts, web3, Wei, reverts, chain
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
    chain.sleep(NFT_LOCK_TIME + 100)
    _account = _account
    frame_token.approve(accounts[5], 100 * TENPOW18, {'from': accounts[0]})

    frame_token.transferFrom(accounts[0], _account, 100 * TENPOW18, {'from':accounts[5]})
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
    


def test_frame_rush_claim_balance_check(frame_rush,collectable_token, frame_token):
    chain.sleep(NFT_LOCK_TIME + 100)
    _account = accounts[3]
    frame_token.approve(accounts[5], 100 * TENPOW18, {'from': accounts[0]})

    frame_token.transferFrom(accounts[0], _account, 100 * TENPOW18, {'from':accounts[5]})
    frame_token.approve(frame_rush, 100 * TENPOW18, {'from': _account})
    
   # _tokenId = _mint_collectable_token(collectable_token,frame_rush)
    tokenId = 1
    frame_rush.claimCollectableToken(_account,tokenId, {"from": _account})
    tokenId = 2
    frame_rush.claimCollectableToken(_account,tokenId, {"from": _account})
    
    assert frame_token.balanceOf(_account) == 50 * TENPOW18




def test_is_token_available(frame_rush,collectable_token, frame_token):
    _account = accounts[3]
    
   # _tokenId = _mint_collectable_token(collectable_token,frame_rush)
    tokenId = 1
    frame_rush, frame_token =  _claimCollectableToken(frame_rush, frame_token,tokenId,_account)

    tokenId = 2
    frame_rush, frame_token =  _claimCollectableToken(frame_rush, frame_token,tokenId,_account)

    assert frame_rush.isTokenIdAvailable(2) == False

def test_is_token_minted(frame_rush,collectable_token, frame_token):
    _account = accounts[3]
    
   # _tokenId = _mint_collectable_token(collectable_token,frame_rush)
    tokenId = 1
    frame_rush, frame_token =  _claimCollectableToken(frame_rush, frame_token,tokenId,_account)
    
    _account = accounts[4]
    tokenId = 2
    frame_rush, frame_token =  _claimCollectableToken(frame_rush, frame_token,tokenId,_account)

    tokenId = 1
    assert collectable_token.ownerOf(tokenId) == accounts[3]

    tokenId = 2
    assert collectable_token.ownerOf(tokenId) == accounts[4]

def test_should_not_be_claimable_ZERO_ADDRESS(frame_rush,collectable_token, frame_token):
    chain.sleep(NFT_LOCK_TIME + 100)
    _account = ZERO_ADDRESS
    tokenId = 1

    _account = _account
    frame_token.approve(accounts[5], 100 * TENPOW18, {'from': accounts[0]})

    frame_token.transferFrom(accounts[0], accounts[3], 100 * TENPOW18, {'from':accounts[5]})
    frame_token.approve(_account, 100 * TENPOW18, {'from': accounts[0]})
    frame_token.approve(frame_rush, 100 * TENPOW18, {'from': accounts[0]})
    with reverts("Frame Rush: Token cannot be claimed"):
        frame_rush.claimCollectableToken(_account,tokenId, {"from": accounts[0]})

    
def test_get_closest_token_id(frame_rush, frame_token):
    _account = accounts[3]
    
   # _tokenId = _mint_collectable_token(collectable_token,frame_rush)
    tokenId = 1
    frame_rush, frame_token =  _claimCollectableToken(frame_rush, frame_token,tokenId,_account)

    tokenId = 2
    frame_rush, frame_token =  _claimCollectableToken(frame_rush, frame_token,tokenId,_account)

    assert frame_rush.isTokenIdAvailable(2) == False

    assert 3 == frame_rush.getClosestTokenIdAvailable(tokenId)

def test_should_not_be_claimable_LOCK_PERIOD(frame_rush, frame_token):
    _account = accounts[3]
   # _tokenId = _mint_collectable_token(collectable_token,frame_rush)
    tokenId = 1

    _account = _account
    frame_token.approve(accounts[5], 100 * TENPOW18, {'from': accounts[0]})

    frame_token.transferFrom(accounts[0], _account, 100 * TENPOW18, {'from':accounts[5]})
    frame_token.approve(frame_rush, 100 * TENPOW18, {'from': _account})
    
    with reverts("Frame Rush: Token cannot be claimed"):
        frame_rush.claimCollectableToken(_account,tokenId, {"from": _account})