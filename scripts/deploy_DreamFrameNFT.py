from brownie import *
from .contract_addresses import *

def load_accounts():
    if network.show_active() == 'mainnet':
        # replace with your keys
        accounts.load("Gaze")
    # add accounts if active network is goerli
    if network.show_active() in ['goerli', 'ropsten','kovan','rinkeby']:
        # 0xa5C9fb5D557daDb10c4B5c70943d610001B7420E 
        accounts.add('6a202283db75b6ea23175f3c795d4e73154a28bd7e72ec0d31a8ab76f9d80200')
        # 0x9135C43D7bA230d372A12B354c2E2Cf58b081463
        accounts.add('6a202283db75b6ea23175f3c795d4e73154a28bd7e72ec0d31a8ab76f9d80201')

def deploy_dream_frames_NFT():
    deployer = accounts[0]
    dream_frames_NFT_address = CONTRACTS[network.show_active()]["dream_frames_NFT"]

    if dream_frames_NFT_address == '':
        dream_frames_NFT = DreamFramesNFT.deploy({"from":accounts[0]})
    else:
        dream_frames_NFT = DreamFramesNFT.at(dream_frames_NFT_address)
    return dream_frames_NFT



def main():
    load_accounts()
    deploy_dream_frames_NFT()

