from brownie import *
import time

def deploy_frame_token():
    if network.show_active() == 'ropsten':
        frame_token_address = web3.toChecksumAddress(0xd504b89d9a6a995e730344ace1738aba2ce6441b)
    frame_token = DreamFramesToken.at(frame_token_address)
    return frame_token

def deploy_royalty_token():
    if network.show_active() == 'ropsten':
        royalty_token_address = web3.toChecksumAddress(0x68a6a53c47322426c9ba35fe2c430585eb828ec1)
    royalty_token = RoyaltyToken.at(royalty_token_address)
    return royalty_token

def deploy_bonus_list():
    bonus_list = WhiteList.deploy({"from": accounts[0]})
    bonus_list.initWhiteList(accounts[0], {"from": accounts[0]})
    return bonus_list

def deploy_price_feed():
    if network.show_active() == 'ropsten':
        price_feed_address = web3.toChecksumAddress(0x31e206f5Aa5Dfae6CCBb980fE9eE5fcd52a32978)
    price_feed = MakerDAOPriceFeedAdaptor.at(price_feed_address)
    return price_feed


def deploy_frames_crowdsale(frame_token, price_feed, bonus_list):
    wallet = accounts[1]
    startDate = int(time.time())
    days = 5
    endDate = startDate + 60 * 60 * 24 * days
    minFrames = 1
    maxFrames  = 100000
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
    tx = frames_crowdsale.setBonusList(bonus_list, {"from": accounts[0]})

    return frames_crowdsale

def deploy_token_converter(frame_token, royalty_token):
    token_converter = RoyaltyTokenConverter.deploy({"from": accounts[0]})
    token_converter.initTokenConverter(frame_token,royalty_token, True, {"from": accounts[0]})
    tx = royalty_token.setMinter(token_converter, {"from": accounts[0]})
    return token_converter

def main():
    # add accounts if active network is ropsten
    if network.show_active() == 'ropsten':
        # 0x2A40019ABd4A61d71aBB73968BaB068ab389a636
        accounts.add('4ca89ec18e37683efa18e0434cd9a28c82d461189c477f5622dae974b43baebf')

        # 0x1F3389Fc75Bf55275b03347E4283f24916F402f7
        accounts.add('fa3c06c67426b848e6cef377a2dbd2d832d3718999fbe377236676c9216d8ec0')


    frame_token = deploy_frame_token()
    royalty_token = deploy_royalty_token()
    deploy_price = deploy_price_feed()
    bonus_list = deploy_bonus_list()

    frames_crowdsale = deploy_frames_crowdsale(frame_token, price_feed, bonus_list)

    # token_converter = deploy_token_converter(frame_token, royalty_token)

    # # deploy and set token factory (also add dream frames factory as an operator of token factory)
    # token_factory = TokenFactory.deploy({'from': accounts[0]})
    # token_factory.addOperator(dream_frames_factory)
    # dream_frames_factory.setTokenFactory(token_factory)

    # # deploy and set royalty token factory (also add dream frames factory as an operator of royalty token factory)
    # royalty_token_factory = RoyaltyTokenFactory.deploy({'from': accounts[0]})
    # royalty_token_factory.addOperator(dream_frames_factory)
    # dream_frames_factory.setRoyaltyTokenFactory(royalty_token_factory)







# Running 'scripts.deploy_TokenCrowdsale.main'...
# Transaction sent: 0xf787b544ad201e06d8e116bbc039b3c3033e7399c5ae30a7e2e9038fe1adde7f
#   Gas price: 1.0 gwei   Gas limit: 346697
# Waiting for confirmation...
#   MakerDAOETHUSDPriceFeedSimulator.constructor confirmed - Block: 7811762   Gas used: 346697 (100.00%)
#   MakerDAOETHUSDPriceFeedSimulator deployed at: 0xb60a463bBc431Af8B9F807a67763d57cD62A688f

# Transaction sent: 0x3c2a7b0579f0b1441e8d343bdac4523846df75b254b611f20fe97719536939df
#   Gas price: 1.0 gwei   Gas limit: 146104
# Waiting for confirmation...
#   MakerDAOPriceFeedAdaptor.constructor confirmed - Block: 7811764   Gas used: 146104 (100.00%)
#   MakerDAOPriceFeedAdaptor deployed at: 0x31e206f5Aa5Dfae6CCBb980fE9eE5fcd52a32978

# Transaction sent: 0x7bbe604281222d8221de998117f28b7a5b2e62224d474be91b0cac0a330dd7a8
#   Gas price: 1.0 gwei   Gas limit: 587550
# Waiting for confirmation...
#   WhiteList.constructor confirmed - Block: 7811766   Gas used: 587550 (100.00%)
#   WhiteList deployed at: 0x0FD555484b9be247A0b05B8Bb1755C75169650D0

# Transaction sent: 0x3df9a33447194fd23a3c5c2af5ef4cd55aa3153be834b5a014c1e811c0b80492
#   Gas price: 1.0 gwei   Gas limit: 64277
# Waiting for confirmation...
#   WhiteList.initWhiteList confirmed - Block: 7811769   Gas used: 64277 (100.00%)

# Transaction sent: 0x8863612e91a61e137c91d0d279f38bcef3738408eef607e119fdae5c2469fd5b
#   Gas price: 1.0 gwei   Gas limit: 1764403
# Waiting for confirmation...
#   DreamFramesCrowdsale.constructor confirmed - Block: 7811772   Gas used: 1764403 (100.00%)
#   DreamFramesCrowdsale deployed at: 0xd0E93209fb0a6E5997eA2178Fbf55397cC10026E

# Transaction sent: 0xc35f76e987eba44c8b7cfa919e7de5495f8e2eee1ec6998b3718c6f750a77865
#   Gas price: 1.0 gwei   Gas limit: 349821
# Waiting for confirmation...
#   DreamFramesCrowdsale.init confirmed - Block: 7811774   Gas used: 349821 (100.00%)

# Transaction sent: 0x020a76cb850b698dfcbaf631a00daf225026eb156276124110f564cd63fba404
#   Gas price: 1.0 gwei   Gas limit: 45508
# Waiting for confirmation...
#   DreamFramesCrowdsale.addOperator confirmed - Block: 7811776   Gas used: 45508 (100.00%)

# Transaction sent: 0xcc77a28949eb2323f796c85f73b11c85e4f53d226a410a9b45ead5202310ba74
#   Gas price: 1.0 gwei   Gas limit: 34532
# Waiting for confirmation...
#   DreamFramesToken.setMinter confirmed - Block: 7811778   Gas used: 34254 (99.19%)

# Transaction sent: 0x5c78b9003b29a53de7e487a216887ec7acc128382ccef058a9d7bc5084c95c89
#   Gas price: 1.0 gwei   Gas limit: 44238
# Waiting for confirmation...
#   DreamFramesCrowdsale.setBonusList confirmed - Block: 7811780   Gas used: 44238 (100.00%)