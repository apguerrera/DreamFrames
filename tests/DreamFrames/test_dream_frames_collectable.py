from brownie import accounts, web3, Wei, reverts
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract
from settings import *

@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass

def _mint_multiple_tokens(collectable_token):
    _tokenId = 1
    _to = accounts[0]
    collectable_token.mint(_to,_tokenId)

    _tokenId = 2
    _to = accounts[0]
    collectable_token.mint(_to,_tokenId)

    _tokenId = 3
    _to = accounts[0]
    collectable_token.mint(_to,_tokenId)

    _tokenId = 4
    _to = accounts[1]
    collectable_token.mint(_to,_tokenId)

    _tokenId = 100
    _to = accounts[1]
    collectable_token.mint(_to,_tokenId)

    _tokenId = 102
    _to = accounts[1]
    collectable_token.mint(_to,_tokenId)

    return collectable_token
def test_collectable_token_mint(collectable_token):
    _tokenId = 1
    _to = accounts[0]
    collectable_token.mint(_to,_tokenId)

    assert collectable_token.ownerOf(_tokenId) == accounts[0]

def test_already_minted_token(collectable_token):
    _tokenId = 1
    _to = accounts[0]
    collectable_token.mint(_to,_tokenId)

    assert collectable_token.ownerOf(_tokenId) == accounts[0]
    with reverts("DreamFramesCollectable: Sorry token id already exists"):
        collectable_token.mint(_to,_tokenId)

def test_get_owned_tokens(collectable_token):
    
    collectable_token = _mint_multiple_tokens(collectable_token)
    id1,id2,id3 = collectable_token.getOwnedTokens(accounts[0])

    assert id1 == 1
    assert id2 == 2
    assert id3 == 3

    id4,id5,id6, = collectable_token.getOwnedTokens(accounts[1])
    assert id4 == 4
    assert id5 == 100
    assert id6 == 102
    
    id7 = collectable_token.getOwnedTokens(accounts[7])
    
    assert id7 == ()

def test_get_owned_tokens_zero_address(collectable_token):
    with reverts("DreamFramesCollectable: Owner is zero address"):
        collectable_token.getOwnedTokens(ZERO_ADDRESS)

def test_get_all_token_index(collectable_token):
    collectable_token = _mint_multiple_tokens(collectable_token)
    id1,id2,id3 = collectable_token.getOwnedTokens(accounts[0])
    id4,id5,id6 = collectable_token.getOwnedTokens(accounts[1])
    assert collectable_token.getAllTokensIndex(id1) == 0
    assert collectable_token.getAllTokensIndex(id2) == 1
    assert collectable_token.getAllTokensIndex(id3) == 2
    assert collectable_token.getAllTokensIndex(id4) == 3

    _tokenId = 100
    assert collectable_token.getAllTokensIndex(_tokenId) == 4

    _tokenId = 102
    assert collectable_token.getAllTokensIndex(_tokenId) == 5
