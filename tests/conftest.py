from brownie import accounts, web3, Wei, chain
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract

from settings import *

######################################
# Deploy Contracts
######################################

@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


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
    mintable = True
    transferable = True
    initial_supply = '1000 ether'
    tx = token_factory.deployFrameToken(accounts[0],symbol, name,
                                  initial_supply,mintable,transferable,{'from': accounts[0]})
    frame_token = DreamFramesToken.at(tx.return_value)
    return frame_token




@pytest.fixture(scope='module', autouse=True)
def royalty_token(RoyaltyToken,token_factory):
    name = 'Royalty Token'
    symbol = 'RFT'
    mintable = True
    transferable = True
    initial_supply = '500 ether'
    owner = accounts[0]
    tx = token_factory.deployRoyaltyToken(owner,symbol, name,
                                  initial_supply,mintable,transferable, {'from': accounts[0]})
    royalty_token = RoyaltyToken.at(tx.return_value)
    return royalty_token


@pytest.fixture(scope='module', autouse=True)
def price_simulator(MakerDAOETHUSDPriceFeedSimulator):
    price_simulator = MakerDAOETHUSDPriceFeedSimulator.deploy('200 ether', True, {"from": accounts[0]})
    return price_simulator

@pytest.fixture(scope='module', autouse=True)
def price_feed(MakerDAOPriceFeedAdaptor, price_simulator):
    price_feed = MakerDAOPriceFeedAdaptor.deploy(price_simulator, {"from": accounts[0]})
    return price_feed


# @pytest.fixture(scope='module', autouse=True)
# def price_feed(CompoundPriceFeedAdaptor):
#     price_feed = CompoundPriceFeedAdaptor.deploy(COMPOUND_ORACLE, {"from": accounts[0]})
#     return price_feed

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
    startDate = chain.time() +10
    endDate = startDate + 50000

    frames_crowdsale = DreamFramesCrowdsale.deploy({"from": accounts[0]})
    frames_crowdsale.init(frame_token, price_feed
                    , wallet, startDate, endDate
                    , PRODUCER_PCT, FRAME_USD, BONUS,BONUS_ON_LIST, HARDCAP_USD, SOFTCAP_USD
                    , {"from": accounts[0]})
    tx = frames_crowdsale.addOperator(accounts[1], {"from": accounts[0]})
    assert 'OperatorAdded' in tx.events
    tx = frame_token.setMinter(frames_crowdsale, {"from": accounts[0]})
    tx = frames_crowdsale.setBonusList(bonus_list, {"from": accounts[0]})
    chain.sleep(15)
    return frames_crowdsale


@pytest.fixture(scope='module', autouse=True)
def token_converter(RoyaltyTokenConverter, frame_token, royalty_token):
    token_converter = RoyaltyTokenConverter.deploy({"from": accounts[0]})
    token_converter.initTokenConverter(frame_token,royalty_token, True, {"from": accounts[0]})
    tx = royalty_token.setMinter(token_converter, {"from": accounts[0]})
    return token_converter

@pytest.fixture(scope='module', autouse = True)
def dream_frames_nft(DreamChannelNFT):
    dream_frames_nft = DreamChannelNFT.deploy({"from": accounts[0]})
    return dream_frames_nft

@pytest.fixture(scope='module', autouse = True)
def frame_rush(FrameRush, frame_token, collectable_token):
    frame_rush = FrameRush.deploy({"from": accounts[3]})

    _isClaimable = True
    _lockPeriod = 0
    frame_rush.initFrameRush(frame_token, collectable_token,_isClaimable, _lockPeriod, {"from": accounts[0]})
    return frame_rush

@pytest.fixture(scope = 'module', autouse=True)
def collectable_token(DreamFramesCollectable):
    _name = "VR Collectibles"
    _symbol = "VRC"
    dream_collectables = DreamFramesCollectable.deploy(_name, _symbol,{"from": accounts[0]})
    return dream_collectables

################################
#Staking
################################
@pytest.fixture(scope='module',autouse= True)
def access_control(GazeAccessControls):
    access_control = GazeAccessControls.deploy({"from":accounts[0]}) 
    return access_control


@pytest.fixture(scope='module', autouse=True)
def btts_lib_gaze(BTTSLibGaze):
    btts_lib_gaze = BTTSLibGaze.deploy({'from': accounts[0]})
    return btts_lib_gaze

@pytest.fixture(scope='module', autouse=True)
def gaze_coin(BTTSToken, btts_lib_gaze):
    name = "GazeCoin Metaverse Token"
    symbol = "GZE"
    owner = accounts[1]
    initialSupply = 29000000 * 10 ** 18
    gaze_coin = BTTSToken.deploy(owner,symbol, name, 18, initialSupply, False, True, {"from":owner})

    return gaze_coin

@pytest.fixture(scope='module', autouse=True)
def weth_token(WETH9):
    weth_token = WETH9.deploy({'from': accounts[0]})
    return weth_token

@pytest.fixture(scope='module', autouse=True)
def lp_factory(UniswapV2Factory):
    
    lp_factory = UniswapV2Factory.deploy(accounts[0], {'from': accounts[0]})
    return lp_factory

@pytest.fixture(scope='module', autouse=True)
def lp_token(UniswapV2Pair, weth_token, gaze_coin,lp_factory):
    lp_token_deployer = accounts[5]
   # lp_token = UniswapV2Pair.deploy({"from":lp_token_deployer})

    lp_token = lp_factory.createPair(weth_token, gaze_coin, {"from": lp_token_deployer}).return_value
    lp_token = UniswapV2Pair.at(lp_token)
    weth_token.deposit({'from': accounts[0], 'value': 1 * 10**18})
    gaze_coin.transfer(lp_token, 100000 * 10**18, {'from':accounts[1]})
    weth_token.transfer( lp_token,1 * 10**18,{'from':accounts[0]})
    lp_token.mint(accounts[0],{'from':accounts[0]})

    return lp_token

""" @pytest.fixture(scope='module', autouse=True)
def lp_token_from_fork(gaze_coin,weth_token,interface):
    uniswap_factory = interface.IUniswapV2Factory(UNISWAP_FACTORY)
    tx = uniswap_factory.createPair(gaze_coin, weth_token, {'from': accounts[0]})
    assert 'PairCreated' in tx.events
    lp_token_from_fork = interface.IUniswapV2Pair(web3.toChecksumAddress(tx.events['PairCreated']['pair']))
    return lp_token_from_fork """

@pytest.fixture(scope='module', autouse=True)
def lp_staking(GazeLPStaking,gaze_coin,lp_token,weth_token,access_control):
    lp_staking = GazeLPStaking.deploy({'from':accounts[0]})
    lp_staking.initLPStaking(gaze_coin,lp_token,weth_token,access_control,{"from":accounts[0]})

    lp_staking.setTokensClaimable(True)

    return lp_staking



##############################################
# Rewards
##############################################

@pytest.fixture(scope = 'module', autouse = True)
def rewards_contract(GazeRewards,access_control,gaze_coin, lp_staking):
    vault = accounts[1]
    rewards_contract = GazeRewards.deploy(gaze_coin,
                                        access_control,
                                        lp_staking,
                                        chain.time() +10,
                                        0,
                                        0,
                                        {'from': accounts[0]})



    return rewards_contract


@pytest.fixture(scope='module', autouse=True)
def staking_rewards(GazeLPStaking, GazeRewards, gaze_coin, lp_token, weth_token, access_control):
    staking_rewards = GazeLPStaking.deploy({'from':accounts[0]})
    staking_rewards.initLPStaking(gaze_coin,lp_token,weth_token,access_control,{"from":accounts[0]})

    vault = accounts[1]
    rewards_contract = GazeRewards.deploy(gaze_coin,
                                        access_control,
                                        staking_rewards,
                                        chain.time() +10,
                                        0,
                                        0,
                                        {'from': accounts[0]})


    assert gaze_coin.balanceOf(vault) > 0
    gaze_coin.approve(rewards_contract, ONE_MILLION, {"from":vault} )
    rewards_contract.setVault(vault, {"from":accounts[0]})

    staking_rewards.setRewardsContract(rewards_contract, {"from":accounts[0]})
    staking_rewards.setTokensClaimable(True, {"from":accounts[0]})

    weeks = [0,1,2,3,4,5]
    rewards = [70000*TENPOW18,60000*TENPOW18,50000*TENPOW18,50000*TENPOW18,45000*TENPOW18,42000*TENPOW18]
    rewards_contract.setRewards(weeks,rewards)

    chain.sleep(20)
    chain.mine()

    return staking_rewards