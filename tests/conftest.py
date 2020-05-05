from brownie import accounts, web3, Wei, rpc
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract

ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'

######################################
# Deploy Contracts
######################################


@pytest.fixture(scope='module', autouse=True)
def btts_lib(BTTSLib):
    btts_lib = BTTSLib.deploy({'from': accounts[0]})
    return btts_lib

@pytest.fixture(scope='module', autouse=True)
def frame_token_template(DreamFramesToken, btts_lib):
    frame_token_template = DreamFramesToken.deploy({'from': accounts[0]})
    return frame_token_template

@pytest.fixture(scope='module', autouse=True)
def royalty_token_template(RoyaltyToken, btts_lib):
    royalty_token_template = RoyaltyToken.deploy({'from': accounts[0]})
    return royalty_token_template

@pytest.fixture(scope='module', autouse=True)
def white_list_template(WhiteList):
    white_list_template = WhiteList.deploy({"from": accounts[0]})
    return white_list_template


@pytest.fixture(scope='module', autouse=True)
def token_factory(TokenFactory, frame_token_template, royalty_token_template, white_list_template):
    token_factory = TokenFactory.deploy(frame_token_template,royalty_token_template,white_list_template,0, {"from": accounts[0]})
    return token_factory

@pytest.fixture(scope='module', autouse=True)
def frame_token(token_factory, DreamFramesToken):
    name = 'Dream Frame Token'
    symbol = 'DFT'
    decimals = 18
    mintable = True
    transferable = True
    initial_supply = '1000 ether'
    tx = token_factory.deployFrameToken(accounts[0],symbol, name,decimals,
                                  initial_supply,mintable,transferable,{'from': accounts[0]})
    frame_token = DreamFramesToken.at(tx.return_value)
    return frame_token




@pytest.fixture(scope='module', autouse=True)
def royalty_token(RoyaltyToken,token_factory):
    name = 'Royalty Token'
    symbol = 'RFT'
    decimals = 18
    mintable = True
    transferable = True
    initial_supply = '500 ether'
    owner = accounts[0]
    tx = token_factory.deployRoyaltyToken(owner,symbol, name,
                                  decimals,
                                  initial_supply,mintable,transferable, {'from': accounts[0]})
    royalty_token = RoyaltyToken.at(tx.return_value)
    return royalty_token


@pytest.fixture(scope='module', autouse=True)
def price_simulator(MakerDAOETHUSDPriceFeedSimulator):
    price_simulator = MakerDAOETHUSDPriceFeedSimulator.deploy('20000 ether', True, {"from": accounts[0]})
    return price_simulator

@pytest.fixture(scope='module', autouse=True)
def price_feed(MakerDAOPriceFeedAdaptor, price_simulator):
    price_feed = MakerDAOPriceFeedAdaptor.deploy(price_simulator, {"from": accounts[0]})
    return price_feed

@pytest.fixture(scope='module', autouse=True)
def white_list(token_factory, WhiteList):
    tx = token_factory.deployWhiteList(accounts[0], [accounts[0]], {'from': accounts[0]})
    white_list = WhiteList.at(tx.return_value)
    return white_list

@pytest.fixture(scope='module', autouse=True)
def bonus_list(WhiteList):
    bonus_list = WhiteList.deploy({"from": accounts[0]})
    bonus_list.initWhiteList(accounts[0], {"from": accounts[0]})
    return bonus_list

@pytest.fixture(scope='module', autouse=True)
def frames_crowdsale(DreamFramesCrowdsale, frame_token, price_feed, bonus_list):
    wallet = accounts[9]
    startDate = rpc.time()
    endDate = startDate + 50000
    minFrames = 1
    maxFrames  = 1000000
    producerFrames = 25000
    frameUsd = '100 ether'
    bonusOffList = 30 
    bonusOnList = 40 
    hardCapUsd = '3000000 ether'
    softCapUsd = '1500000 ether' 
    frames_crowdsale = DreamFramesCrowdsale.deploy({"from": accounts[0]})
    frames_crowdsale.init(frame_token, price_feed
                    , wallet, startDate, endDate, minFrames
                    , maxFrames, producerFrames, frameUsd, bonusOffList,bonusOnList, hardCapUsd, softCapUsd
                    , {"from": accounts[1]})
    tx = frames_crowdsale.addOperator(accounts[1], {"from": accounts[0]})
    assert 'OperatorAdded' in tx.events
    tx = frame_token.setMinter(frames_crowdsale, {"from": accounts[0]})
    tx = frames_crowdsale.setBonusList(bonus_list, {"from": accounts[0]})

    return frames_crowdsale


@pytest.fixture(scope='module', autouse=True)
def token_converter(RoyaltyTokenConverter, frame_token, royalty_token):
    token_converter = RoyaltyTokenConverter.deploy({"from": accounts[0]})
    token_converter.initTokenConverter(frame_token,royalty_token, True, {"from": accounts[0]})
    tx = royalty_token.setMinter(token_converter, {"from": accounts[0]})
    return token_converter