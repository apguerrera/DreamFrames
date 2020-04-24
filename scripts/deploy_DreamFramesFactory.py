from brownie import *


def main():
    # add accounts if active network is ropsten
    if network.show_active() == 'ropsten':
        # 0x2A40019ABd4A61d71aBB73968BaB068ab389a636
        accounts.add('4ca89ec18e37683efa18e0434cd9a28c82d461189c477f5622dae974b43baebf')

        # 0x1F3389Fc75Bf55275b03347E4283f24916F402f7
        accounts.add('fa3c06c67426b848e6cef377a2dbd2d832d3718999fbe377236676c9216d8ec0')

    dream_frames_factory = DreamFramesFactory.deploy({'from': accounts[0]})

    # Deploy BTTSLib library
    BTTSLib.deploy({'from': accounts[0]})

    # deploy and set whitelist
    whitelist = WhiteList.deploy({'from': accounts[0]})
    dream_frames_factory.setWhiteList(whitelist)

    # deploy and set token factory (also add dream frames factory as an operator of token factory)
    token_factory = TokenFactory.deploy({'from': accounts[0]})
    token_factory.addOperator(dream_frames_factory)
    dream_frames_factory.setTokenFactory(token_factory)

    # deploy and set royalty token factory (also add dream frames factory as an operator of royalty token factory)
    royalty_token_factory = RoyaltyTokenFactory.deploy({'from': accounts[0]})
    royalty_token_factory.addOperator(dream_frames_factory)
    dream_frames_factory.setRoyaltyTokenFactory(royalty_token_factory)

    # deploy and set price feed
    price_feed_simulator = MakerDAOETHUSDPriceFeedSimulator.deploy(200, True, {'from': accounts[0]})
    price_feed_adaptor = MakerDAOPriceFeedAdaptor.deploy(price_feed_simulator, {'from': accounts[0]})
    dream_frames_factory.setPriceFeed(price_feed_adaptor)

    # deploy new token contract via dream frames factory
    dream_frames_factory.deployTokenContract(accounts[1], 'TST', 'Test Token', 18, '10 ether', True, True)

    # deploy new royalty token contract via dream frames factory
    dream_frames_factory.deployRoyaltyTokenContract(accounts[1], 'TRT', 'Test Royalty Token', 18, '5 ether', True, True)
