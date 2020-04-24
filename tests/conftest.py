from brownie import accounts, web3, Wei, rpc
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract


######################################
# Deploy Contracts
######################################


    

@pytest.fixture(scope='module', autouse=True)
def btts_lib(BTTSLib):
    btts_lib = BTTSLib.deploy({'from': accounts[0]})
    return btts_lib

@pytest.fixture(scope='module', autouse=True)
def frame_token(DreamFramesToken, btts_lib):
    name = 'Dream Frame Token'
    symbol = 'DFT'
    decimals = 18
    mintable = True
    transferable = True
    initial_supply = '1000 ether'
    frame_token = DreamFramesToken.deploy({'from': accounts[0]})
    frame_token.init(accounts[0],symbol, name,
                                  decimals,
                                  initial_supply,mintable,transferable,
                                  {'from': accounts[0]})
    return frame_token


@pytest.fixture(scope='module', autouse=True)
def white_list(WhiteList):
    white_list = WhiteList.deploy({"from": accounts[0]})
    return white_list

@pytest.fixture(scope='module', autouse=True)
def bonus_list(BonusList):
    bonus_list = BonusList.deploy({"from": accounts[0]})
    return bonus_list


@pytest.fixture(scope='module', autouse=True)
def bonus_list(BonusList):
    bonus_list = BonusList.deploy({"from": accounts[0]})
    return bonus_list

@pytest.fixture(scope='module', autouse=True)
def price_simulator(MakerDAOETHUSDPriceFeedSimulator):
    price_simulator = MakerDAOETHUSDPriceFeedSimulator.deploy('200 ether', True, {"from": accounts[0]})
    return price_simulator

@pytest.fixture(scope='module', autouse=True)
def price_feed(MakerDAOPriceFeedAdaptor, price_simulator):
    price_feed = MakerDAOPriceFeedAdaptor.deploy(price_simulator, {"from": accounts[0]})
    return price_feed

@pytest.fixture(scope='module', autouse=True)
def frames_crowdsale(DreamFramesCrowdsale, frame_token, price_feed):
    wallet = accounts[1]
    startDate = rpc.time()
    endDate = startDate + 50000
    minFrames = 1
    maxFrames  = '100000 ether'
    producerFrames = 25000
    frameUsd = '100 ether'
    bonusOffList = 30 
    bonusOnList = 40 
    hardCapUsd = 3000000
    softCapUsd = 1500000
    frames_crowdsale = DreamFramesCrowdsale.deploy({"from": accounts[0]})
    frames_crowdsale.init(frame_token, price_feed
                    , wallet, startDate, endDate, minFrames
                    , maxFrames, producerFrames, frameUsd, bonusOffList,bonusOnList, hardCapUsd, softCapUsd
                    , {"from": accounts[0]})
    tx = frames_crowdsale.addOperator(accounts[1], {"from": accounts[0]})
    assert 'OperatorAdded' in tx.events
    tx = frame_token.setMinter(frames_crowdsale, {"from": accounts[0]})

    return frames_crowdsale
