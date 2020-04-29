from brownie import accounts, web3, Wei, Contract
from brownie.network.transaction import TransactionReceipt


# PetylBaseToken contract deployment

def main():

    name = 'BASE TOKEN'
    symbol = 'BTN'
    default_operators = (accounts[0],)
    burn_operator = accounts[0]
    # controller = accounts[0]
    initial_supply = '1000 ether'
    frame_token = DreamFramesToken.deploy({'from': accounts[0]})
    frame_token.initFrameToken(accounts[0], name,
                                  symbol,
                                  default_operators,
                                  burn_operator,
                                  initial_supply,
                                  {'from': accounts[0]})


    return frame_token
