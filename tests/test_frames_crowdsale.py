from brownie import accounts, web3, Wei, reverts, rpc
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract

ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'
FRAME_USD = 100 * (10**18)
BONUS = 30 
FRAME_USD_BONUS = int( FRAME_USD * 100 / (100 + BONUS ))


# reset the chain after every test case
@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass

def dust(value):
    return int(value / 10 ** 6 )


######################################
# Owned
######################################

def test_frames_crowdsale_owned(frames_crowdsale):
    assert frames_crowdsale.owner({'from': accounts[0]}) == accounts[0]

def test_frames_crowdsale_transferOwnership(frames_crowdsale):
    tx = frames_crowdsale.transferOwnership(accounts[1], {'from': accounts[0]})
    tx = frames_crowdsale.acceptOwnership( {'from': accounts[1]})

    assert 'OwnershipTransferred' in tx.events
    assert tx.events['OwnershipTransferred'] == {'previousOwner': accounts[0], 'newOwner': accounts[1]}
    with reverts():
        frames_crowdsale.transferOwnership(accounts[1], {'from': accounts[0]})



######################################
# Bonus List
######################################

def test_frames_crowdsale_setBonusOffList(frames_crowdsale):
    tx = frames_crowdsale.setBonusOffList(50, {'from': accounts[0]})
    assert 'BonusOffListUpdated' in tx.events

def test_frames_crowdsale_setBonusOnList(frames_crowdsale):
    tx = frames_crowdsale.setBonusOnList(50, {'from': accounts[0]})
    assert 'BonusOnListUpdated' in tx.events



######################################
# Frames Calculations 
######################################

def test_frames_crowdsale_mintable(frame_token):
    assert frame_token.mintable({'from': accounts[0]}) == True


def test_frames_crowdsale_ethUsd(frames_crowdsale):
    assert frames_crowdsale.ethUsd({'from': accounts[0]}) == ('200 ether',True)

    
def test_frames_crowdsale_frameUsdWithBonus(frames_crowdsale):
    assert dust(frames_crowdsale.frameUsdWithBonus({'from': accounts[0]}))  == dust(FRAME_USD_BONUS)   # dust


def test_frames_crowdsale_frameUsd(frames_crowdsale):
    assert frames_crowdsale.frameUsd({'from': accounts[0]}) == '100 ether'


def test_frames_crowdsale_frameEth(frames_crowdsale):
    frame_eth = FRAME_USD_BONUS * (10**18) / (200 * 10**18) 
    (rate,live) = frames_crowdsale.frameEth({'from': accounts[0]}) 
    assert live == True
    assert dust(rate) == dust(frame_eth)   # dust 


def test_frames_crowdsale_calculateFrames(frames_crowdsale):
    (frames,eth_to_transfer) = frames_crowdsale.calculateFrames('10 ether', {'from': accounts[0]})
    assert frames == 26
    assert dust(eth_to_transfer) == dust(10 * 10**18)



######################################
# Offline Purchases
######################################

def test_frames_crowdsale_offlineFramesPurchase(frames_crowdsale):
    tokenOwner = accounts[4]
    frames = 10
    tx = frames_crowdsale.offlineFramesPurchase(tokenOwner, frames, {'from': accounts[0]})
    assert 'Purchased' in tx.events
    


######################################
# Finalise Crowdsale
######################################

def test_frames_crowdsale_finalise(frames_crowdsale):
    rpc.sleep(50001)
    tx = frames_crowdsale.finalise( {'from': accounts[0]})
    assert frames_crowdsale.finalised() == True
    with reverts():
        tx = frames_crowdsale.finalise( {'from': accounts[0]})
