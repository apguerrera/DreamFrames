from brownie import *


def deploy_price_feed():
    if network.show_active() == 'ropsten':
        compound_oracle_address = web3.toChecksumAddress(0x6600a2079f724f9da3ece619ae400e1ef16fc284)
    if network.show_active() == 'mainnet':
        compound_oracle_address = web3.toChecksumAddress(0xddc46a3b076aec7ab3fc37420a8edd2959764ec4)    
    
    price_feed = CompoundPriceFeedAdaptor.deploy(compound_oracle_address,{"from": accounts[0]})
    return price_feed

def main():
    # add accounts if active network is ropsten
    if network.show_active() == 'ropsten':
        # 0x2A40019ABd4A61d71aBB73968BaB068ab389a636
        accounts.add('4ca89ec18e37683efa18e0434cd9a28c82d461189c477f5622dae974b43baebf')

        # 0x1F3389Fc75Bf55275b03347E4283f24916F402f7
        accounts.add('fa3c06c67426b848e6cef377a2dbd2d832d3718999fbe377236676c9216d8ec0')


    price_feed =  deploy_price_feed()

 

#  Deployed on Ropsten
#  Running 'scripts.deploy_PriceOracle.main'...
# Transaction sent: 0x3b7ce3e3e6632a4d1957d37995e4c4540807d5db6668d54e73b1c2042ab65874
#   Gas price: 1.0 gwei   Gas limit: 187903
# Waiting for confirmation...
#   CompoundPriceFeedAdaptor.constructor confirmed - Block: 7892088   Gas used: 187903 (100.00%)
#   CompoundPriceFeedAdaptor deployed at: 0x98A20D420bDC161a0ABeC656d147841f793b14b6
