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
    endDate = startDate + 50000
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




