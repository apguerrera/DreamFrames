from brownie import accounts, web3, Wei, reverts, rpc
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract

ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'
FRAME_USD = 100 * (10**18)
ETH_USD = 200 * (10**18)
BONUS = 30 
FRAME_USD_BONUS = int( FRAME_USD * 100 / (100 + BONUS ))
MAX_FRAMES = 100000 
PRODUCER_FRAMES = 25000 

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
    assert tx.events['OwnershipTransferred'] == {'from': accounts[0], 'to': accounts[1]}
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


def test_frames_crowdsale_bonus_add_getBonus(frames_crowdsale, bonus_list):
    employee = accounts[6]
 
    bonus = frames_crowdsale.getBonus(employee, {'from': accounts[0]})
    assert bonus == BONUS
    tx = bonus_list.add([employee], {'from': accounts[0]})
    assert 'AccountListed' in tx.events
    assert bonus_list.isInBonusList(accounts[0]) == False
    assert bonus_list.isInBonusList(employee) == True

    bonus = frames_crowdsale.getBonus(employee, {'from': accounts[0]})
    assert bonus != BONUS

######################################
# Frames Calculations 
######################################

def test_frames_crowdsale_mintable(frame_token):
    assert frame_token.mintable({'from': accounts[0]}) == True


def test_frames_crowdsale_ethUsd(frames_crowdsale):
    assert frames_crowdsale.ethUsd({'from': accounts[0]}) == ('200 ether',True)

    
def test_frames_crowdsale_frameUsdWithBonus(frames_crowdsale):
    assert dust(frames_crowdsale.frameUsdWithBonus(accounts[2], {'from': accounts[0]}))  == dust(FRAME_USD_BONUS)   # AG: dust


def test_frames_crowdsale_frameUsd(frames_crowdsale):
    assert frames_crowdsale.frameUsd({'from': accounts[0]}) == '100 ether'


def test_frames_crowdsale_frameEth(frames_crowdsale):
    target_frame_eth = FRAME_USD_BONUS * (10**18) / (200 * 10**18) 
    (frame_eth,live) = frames_crowdsale.frameEthBonus(accounts[2], {'from': accounts[0]}) 
    assert live == True
    assert dust(frame_eth) == dust(target_frame_eth)   # AG: dust 


def test_frames_crowdsale_calculateFrames(frames_crowdsale):
    (frames,eth_to_transfer) = frames_crowdsale.calculateFrames('10 ether', {'from': accounts[0]})
    assert frames == int(ETH_USD / FRAME_USD_BONUS * 10)
    assert dust(eth_to_transfer) == dust(10 * 10**18)  # AG: dust 

def test_frames_crowdsale_calculateFrames_short(frames_crowdsale):
    (frames,eth_amount) = frames_crowdsale.calculateFrames('9.9 ether', {'from': accounts[0]})
    assert frames == int(ETH_USD / FRAME_USD_BONUS * 9.9)
    (frame_eth, live) = frames_crowdsale.frameEthBonus(accounts[2],{'from': accounts[0]})
    eth_to_transfer = frames * frame_eth
    assert dust(eth_to_transfer) == dust(eth_amount)  # AG: dust 


def test_frames_crowdsale_calculateFrames_hardcap(frames_crowdsale):
    (frames,eth_amount) = frames_crowdsale.calculateFrames('100000 ether', {'from': accounts[0]})
    assert frames == MAX_FRAMES
    (frame_eth, live) = frames_crowdsale.frameEthBonus(accounts[2],{'from': accounts[0]})
    eth_to_transfer = frames * frame_eth
    assert dust(eth_to_transfer) == dust(eth_amount)  # AG: dust 


def test_frames_crowdsale_framesRemaining(frames_crowdsale):
    frames_remaining = frames_crowdsale.framesRemaining({'from': accounts[0]})
    assert frames_remaining == MAX_FRAMES

def test_frames_crowdsale_pctSold(frames_crowdsale):
    pct_sold = frames_crowdsale.pctSold({'from': accounts[0]})
    assert pct_sold == 0

def test_frames_crowdsale_pctRemaining(frames_crowdsale):
    pct_remaining = frames_crowdsale.pctRemaining({'from': accounts[0]})
    assert pct_remaining == 100



######################################
# Purchases with ETH
######################################

def test_frames_crowdsale_purchaseEth(frames_crowdsale,frame_token):

    frames = 10
    (frame_eth, live) = frames_crowdsale.frameEthBonus(accounts[3],{'from': accounts[0]})
    eth_to_transfer = frames * frame_eth

    tx = accounts[3].transfer(frames_crowdsale, eth_to_transfer)
    assert 'Purchased' in tx.events
    assert frame_token.balanceOf(accounts[3]) == '{} ether'.format(frames)


def test_frames_crowdsale_purchaseEth_too_much(frames_crowdsale,frame_token):
    tokenOwner = accounts[4]
    frames = 100
    (frame_eth, live) = frames_crowdsale.frameEthBonus(tokenOwner,{'from': tokenOwner})
    eth_to_transfer = frames * frame_eth

    tx = tokenOwner.transfer(frames_crowdsale, eth_to_transfer)
    assert 'Purchased' in tx.events

    tx = frames_crowdsale.offlineFramesPurchase(tokenOwner,MAX_FRAMES-frames, {'from': accounts[0]})
    assert 'Purchased' in tx.events

    assert frame_token.balanceOf(tokenOwner) == MAX_FRAMES * 10 ** 18
    frames_remaining = frames_crowdsale.framesRemaining({'from': accounts[0]})
    assert frames_remaining == 0



######################################
# Locked Accounts
######################################

def test_frames_crowdsale_locked_tokens(frames_crowdsale,frame_token):
    tokenOwner = accounts[4]
    frames = int(10001 * 10 ** 18 /  frames_crowdsale.frameUsdWithBonus(tokenOwner,{'from': accounts[0]}))
    tx = frames_crowdsale.offlineFramesPurchase(tokenOwner,frames, {'from': accounts[0]})
    assert 'Purchased' in tx.events
    assert frame_token.balanceOf(tokenOwner) == frames * 10 ** 18
    with reverts():
        frame_token.transfer(accounts[5], '1 ether', {'from': tokenOwner})

    # Unlock account
    frame_token.unlockAccount(tokenOwner, {'from': accounts[0]})
    tx = frame_token.transfer(accounts[5], '1 ether', {'from': tokenOwner})
    assert 'Transfer' in tx.events

        

######################################
# Offline Purchases
######################################

def test_frames_crowdsale_offlineFramesPurchase(frames_crowdsale):
    tokenOwner = accounts[4]
    frames = 10
    tx = frames_crowdsale.offlineFramesPurchase(tokenOwner, frames, {'from': accounts[0]})
    assert 'Purchased' in tx.events
    frames_remaining = frames_crowdsale.framesRemaining({'from': accounts[0]})
    assert frames_remaining == MAX_FRAMES - frames


######################################
# Finalise Crowdsale
######################################

def test_frames_crowdsale_finalise(frames_crowdsale, frame_token):
    producer = accounts[7]
    rpc.sleep(50001)
    tx = frames_crowdsale.finalise( producer, {'from': accounts[0]})
    assert frames_crowdsale.finalised({'from': accounts[0]}) == True
    assert frame_token.balanceOf(producer, {'from': accounts[0]}) == PRODUCER_FRAMES * 10 ** 18
    with reverts():
        tx = frames_crowdsale.finalise(  producer,{'from': accounts[0]})
