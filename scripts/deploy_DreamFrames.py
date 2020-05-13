from brownie import *

def deploy_frame_token(token_factory):
    name = 'Dream Frame Token'
    symbol = 'DFT'
    decimals = 18
    mintable = True
    transferable = True
    initial_supply = '1000 ether'
    tx = token_factory.deployFrameToken(accounts[0],symbol, name,decimals,
                                  initial_supply,mintable,transferable,{'from': accounts[0]})
    frame_token = DreamFramesToken.at(tx.events['FrameTokenDeployed']['addr'])
    return frame_token

def deploy_royalty_token(token_factory):
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
    royalty_token = RoyaltyToken.at(tx.events['RoyaltyTokenDeployed']['addr'])
    return royalty_token

def deploy_bonus_list():
    bonus_list = WhiteList.deploy({"from": accounts[0]})
    bonus_list.initWhiteList(accounts[0], {"from": accounts[0]})
    return bonus_list

def deploy_price_feed():
    if network.show_active() == 'ropsten':
        compound_oracle_address = web3.toChecksumAddress(0x5722a3f60fa4f0ec5120dcd6c386289a4758d1b2)
        price_feed = CompoundPriceFeedAdaptor.deploy(compound_oracle_address, {"from": accounts[0]})
    return price_feed


def deploy_frames_crowdsale(frame_token, price_feed, bonus_list):
    wallet = accounts[1]
    startDate = int(time.time())
    days = 7
    endDate = startDate + 60 * 60 * 24 * days

    producerPct = 30
    frameUsd = '100 ether'
    bonusOffList = 10 
    bonusOnList = 30 
    hardCapUsd = '3000000 ether'
    softCapUsd = '1500000 ether' 
    frames_crowdsale = DreamFramesCrowdsale.deploy({"from": accounts[0]})
    frames_crowdsale.init(frame_token, price_feed
                    , wallet, startDate, endDate
                    , producerPct, frameUsd, bonusOffList,bonusOnList, hardCapUsd, softCapUsd
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


    # Deploy BTTSLib library
    BTTSLib.deploy({'from': accounts[0]})
    white_list_template = WhiteList.deploy({"from": accounts[0]})
    frame_token_template = DreamFramesToken.deploy({'from': accounts[0]})
    royalty_token_template = RoyaltyToken.deploy({'from': accounts[0]})


    token_factory = TokenFactory.deploy(frame_token_template,
                        royalty_token_template,white_list_template,0, {"from": accounts[0]})

    frame_token = deploy_frame_token(token_factory)
    royalty_token = deploy_royalty_token(token_factory)

    # price_simulator = MakerDAOETHUSDPriceFeedSimulator.deploy('200 ether', True, {"from": accounts[0]})
    # price_feed = MakerDAOPriceFeedAdaptor.deploy(price_simulator, {"from": accounts[0]})

    price_feed =  deploy_price_feed()

    bonus_list = deploy_bonus_list()

    frames_crowdsale = deploy_frames_crowdsale(frame_token, price_feed, bonus_list)
    token_converter = deploy_token_converter(frame_token, royalty_token)



    # Running 'scripts.deploy_DreamFramesFactory.main'...
    # Transaction sent: 0x160299d095716daadda96895bf45ae08a512477dba5c47b989f0de2fc22b0d22
    # Gas price: 1.0 gwei   Gas limit: 3114909
    # Waiting for confirmation...
    # BTTSLib.constructor confirmed - Block: 7810615   Gas used: 3114909 (100.00%)
    # BTTSLib deployed at: 0x4CA2cB1F289c68c651F7778274d405B0a1c3728b

    # Transaction sent: 0xc399738304b7131c5de6d9bae9efaff0dd848eeb4ac26b0d2d5acff8bdd6aa6c
    # Gas price: 1.0 gwei   Gas limit: 587550
    # Waiting for confirmation...
    # WhiteList.constructor confirmed - Block: 7810617   Gas used: 587550 (100.00%)
    # WhiteList deployed at: 0xE9979d9707933DAd414a32f064e594665B012D10

    # Transaction sent: 0x29e86062d58784baa74eddca9ad5ade3cf5c7b5a9337a5e5e41b52630fc44201
    # Gas price: 1.0 gwei   Gas limit: 2298807
    # Waiting for confirmation...
    # DreamFramesToken.constructor confirmed - Block: 7810619   Gas used: 2298807 (100.00%)
    # DreamFramesToken deployed at: 0x75FA1fd0B44B5da825517076C34dfdc1c7ba419D

    # Transaction sent: 0x9dd58ddb03f14a25903eb5fadfea1195921085f10a670ef0de2d0cfc70ee12fb
    # Gas price: 1.0 gwei   Gas limit: 2967894
    # Waiting for confirmation...
    # RoyaltyToken.constructor confirmed - Block: 7810622   Gas used: 2967894 (100.00%)
    # RoyaltyToken deployed at: 0x026325CD02334Ea1b58F58799628e737b25BcdD0

    # Transaction sent: 0x699b44759a03c99694891d1d0f4b18c116920095438a5646b8a6accedd32b3b7
    # Gas price: 1.0 gwei   Gas limit: 1184049
    # Waiting for confirmation...
    # TokenFactory.constructor confirmed - Block: 7810625   Gas used: 1184049 (100.00%)
    # TokenFactory deployed at: 0x2746C1221D14E3f2dAc0483De424FcEA102d2194

    # Transaction sent: 0x6e8a3bb63f01467a2318c7b0e2c3819b309bac35f1e0115b5b0d594a08e92af1
    # Gas price: 1.0 gwei   Gas limit: 295116
    # Waiting for confirmation...
    # TokenFactory.deployFrameToken confirmed - Block: 7810627   Gas used: 290809 (98.54%)

    # Transaction sent: 0x5ebd417edce90152bb7a300b3c5205bf086e1782b5dbe68a5789330206d2bed4
    # Gas price: 1.0 gwei   Gas limit: 476350
    # Waiting for confirmation...
    # TokenFactory.deployRoyaltyToken confirmed - Block: 7810629   Gas used: 471230 (98.93%)

    # Transaction sent: 0xb5b6fd01387cf3629b185b8e083b431a834148674423aacd5053b697996fb43c
    # Gas price: 1.0 gwei   Gas limit: 346697
    # Waiting for confirmation...
    # MakerDAOETHUSDPriceFeedSimulator.constructor confirmed - Block: 7810632   Gas used: 346697 (100.00%)
    # MakerDAOETHUSDPriceFeedSimulator deployed at: 0xDa927e85845c4489CBEb80A79b23B256c1419A8D

    # Transaction sent: 0x0ed35ce87450429b640301ea792e4a021ce7424c39a685b4b12c89a4b6f214bb
    # Gas price: 1.0 gwei   Gas limit: 146104
    # Waiting for confirmation...
    # MakerDAOPriceFeedAdaptor.constructor confirmed - Block: 7810635   Gas used: 146104 (100.00%)
    # MakerDAOPriceFeedAdaptor deployed at: 0x82A94A9Fe951215ce8aC8192f5B8115551f9a14f

    # Transaction sent: 0xdae2267f7f95cdaa5c3532df56395c85114f68ca7bacc44c8ca9512990e27306
    # Gas price: 1.0 gwei   Gas limit: 587550
    # Waiting for confirmation...
    # WhiteList.constructor confirmed - Block: 7810637   Gas used: 587550 (100.00%)
    # WhiteList deployed at: 0x724732a5300D1E4643349e08671193d27CEaF804

    # Transaction sent: 0x564e233505dba9019375ca229ed41c3544ee0e378b44e5e10a857cad7642946a
    # Gas price: 1.0 gwei   Gas limit: 64277
    # Waiting for confirmation...
    # WhiteList.initWhiteList confirmed - Block: 7810640   Gas used: 64277 (100.00%)


