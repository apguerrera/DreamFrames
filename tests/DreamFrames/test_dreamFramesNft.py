from brownie import accounts, web3, Wei, reverts
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract

@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def _dream_frames_nft_mint(dream_frames_nft, _to, _type, minter):
    _subtype = "Dream"
    _name = "Goober"
    _description = "Film token"
    _tags = "it is good token"
    token_id= dream_frames_nft.mint(_to, _type, _subtype, _name, _description,_tags, {"from": minter}).return_value
    assert dream_frames_nft.ownerOf(token_id) == accounts[0]
    return dream_frames_nft, token_id

def test_dream_frames_nft_mint(dream_frames_nft):
    _to = accounts[0]
    _type = "DreamFrames"

    _dream_frames_nft_mint(dream_frames_nft, _to, _type, accounts[0])
    _dream_frames_nft_mint(dream_frames_nft, _to, _type, accounts[2])

def test_transfer_dream_frames_nft(dream_frames_nft):
    holder = accounts[0]
    _type = "DreamFrames"

    dream_frames_nft, token1 = _dream_frames_nft_mint(dream_frames_nft, holder, _type, accounts[0])
    dream_frames_nft, token2 = _dream_frames_nft_mint(dream_frames_nft, holder, _type, accounts[2])
    
    transfer_to = accounts[5]
    dream_frames_nft.approve(transfer_to, token1, {"from": holder})

    dream_frames_nft.safeTransferFrom(holder, transfer_to, token1, {"from":holder})

    assert dream_frames_nft.isOwnerOf(token1,transfer_to)



def test_attributes_by_mint(dream_frames_nft):
    holder = accounts[0]
    _type = "DreamFrames"

    dream_frames_nft, token1 = _dream_frames_nft_mint(dream_frames_nft, holder, _type, accounts[0])
    dream_frames_nft, token2 = _dream_frames_nft_mint(dream_frames_nft, holder, _type, accounts[2])
    _index = 0
    (key, value, timestamp) = dream_frames_nft.getAttributeByIndex(token1,_index)

    assert key == "type"
    assert value == "DreamFrames"

    _index = 1
    (key, value, timestamp) = dream_frames_nft.getAttributeByIndex(token1,_index)

    assert key == "subtype"
    assert value == "Dream"

    _index = 2

    (key, value, timestamp) = dream_frames_nft.getAttributeByIndex(token1,_index)

    assert key == "name"
    assert value == "Goober"




def test_add_attributes(dream_frames_nft):
    holder = accounts[0]
    _type = "DreamFrames"

    dream_frames_nft, token1 = _dream_frames_nft_mint(dream_frames_nft, holder, _type, accounts[0])
    
    key_to_add = "rarity"
    value_to_add = "very rare"
    dream_frames_nft.addAttribute(token1, key_to_add, value_to_add, {"from": holder})

    _index = 5
    (key, value, timestamp) = dream_frames_nft.getAttributeByIndex(token1,_index)

    assert key == key_to_add
    assert value == value_to_add



def test_remove_attribute(dream_frames_nft):
    holder = accounts[0]
    _type = "DreamFrames"

    dream_frames_nft, token1 = _dream_frames_nft_mint(dream_frames_nft, holder, _type, accounts[0])
    key_to_remove = "name"
    dream_frames_nft.removeAttribute(token1,key_to_remove, {"from":holder})

    with reverts():
        key_to_remove = "type"
        dream_frames_nft.removeAttribute(token1,key_to_remove, {"from":holder})


def test_secondary_account(dream_frames_nft):
    holder = accounts[0]
    _type = "DreamFrames"

    dream_frames_nft, token1 = _dream_frames_nft_mint(dream_frames_nft, holder, _type, accounts[0])    

    secondaryAccount = accounts[9]
    dream_frames_nft.addSecondaryAccount(secondaryAccount, {"from": accounts[0]})

    assert dream_frames_nft.isOwnerOf(token1,secondaryAccount)

def test_remove_secondary_account(dream_frames_nft):

    holder = accounts[0]
    _type = "DreamFrames"

    dream_frames_nft, token1 = _dream_frames_nft_mint(dream_frames_nft, holder, _type, accounts[0])    

    secondaryAccount = accounts[9]
    dream_frames_nft.addSecondaryAccount(secondaryAccount, {"from": accounts[0]})

    assert dream_frames_nft.isOwnerOf(token1,secondaryAccount)

    dream_frames_nft.removeSecondaryAccount(secondaryAccount)

    assert dream_frames_nft.isOwnerOf(token1,secondaryAccount) == False

def test_set_tokenURI(dream_frames_nft):
    holder = accounts[0]
    _type = "DreamFrames"

    dream_frames_nft, token1 = _dream_frames_nft_mint(dream_frames_nft, holder, _type, accounts[0])
    dream_frames_nft, token2 = _dream_frames_nft_mint(dream_frames_nft, holder, _type, accounts[2])

    dream_frames_nft.setTokenURI(token1, "https://something.com", {"from": accounts[0]})
    with reverts("GazeCoinGoobers: set Token URI of token that is not own"):
        dream_frames_nft.setTokenURI(token1, "https://something.com", {"from": accounts[5]})

    assert dream_frames_nft.tokenURI(token1) == "https://something.com"
    

