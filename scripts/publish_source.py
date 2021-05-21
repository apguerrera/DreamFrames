from brownie import *
from .contract_addresses import *
import time

def publish():
    if network.show_active() == "development":
        return False
    else:
        return True

def main():
    publish_Goober_nft()
    
def publish_Goober_nft():
    dream_frames_NFT_address = CONTRACTS[network.show_active()]["dream_frames_NFT"]

    if dream_frames_NFT_address != '':
        goober_nft = DreamFramesNFT.at(goober_nft_address)
        DreamFramesNFT.publish_source(goober_nft)
