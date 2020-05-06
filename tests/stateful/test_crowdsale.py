#!/usr/bin/python3

import brownie
from brownie.test import strategy
from brownie import accounts, web3, Wei, rpc


class StateMachine:
    st_eth = strategy('uint256', max_value="10 ether")
    st_usd = strategy('uint256', max_value="1000000 ether")
    st_sleep = strategy('uint256', max_value=60000)
    st_address = strategy('address')

    def __init__(cls, accounts, contract):
        # deploy the contract at the start of the test
        cls.accounts = accounts
        cls.contract = contract

    def setup(self):
        # zero the deposit amounts at the start of each test run
        self.contributed_usd = 0
        self.hardcap_usd = 3000000 * 10 ** 18  # in USD with 18 decimals
        self.frame_usd = self.contract.frameUsd({'from': accounts[1]})

    def rule_buy_with_eth(self, st_address, st_eth):
        # make a deposit and adjust the local record
        tx = self.contract.calculateEthFrames(st_eth, st_address, {'from': st_address})
        frames = tx[0]
        if frames > 0 :
            self.contract.buyFramesEth({'from': st_address, 'value': st_eth})
            self.contributed_usd += frames * self.contract.frameUsdWithBonus(st_address, {'from': st_address})
        else: 
            with brownie.reverts():
                self.contract.buyFramesEth({'from': st_address, 'value': st_eth})

    def rule_buy_offchain(self, st_address, st_usd):
        # convert dollars into number of frames available to purchase
        tx = self.contract.calculateUsdFrames(st_usd, st_address, {'from': accounts[1]})
        frames = tx[0]
        usd_to_contribute = tx[1] 
        if frames > 0:
            self.contract.offlineFramesPurchase(st_address,frames, {'from': accounts[1]})
            self.contributed_usd += usd_to_contribute
        else:
            with brownie.reverts():
                self.contract.offlineFramesPurchase(st_address,frames, {'from': accounts[1]})         

    def rule_sleep(self, st_sleep):
        rpc.sleep(st_sleep)

    def rule_finalise(self):
        finalised = self.contract.finalised( {'from': accounts[1]})
        if (not finalised and self.contributed_usd + self.frame_usd > self.hardcap_usd):
            self.contract.finalise(accounts[9],{'from': accounts[1]})

    def invariant(self):
        # compare the contract deposit amounts with the local record
        assert (self.contract.contributedUsd() - self.contributed_usd) *2 < 1 * 10 ** 10  # err^2 < 10-8 dp


def test_crowdsale(frames_crowdsale, accounts, state_machine):
    settings = {"stateful_step_count": 20, "max_examples": 50}
    accounts[0].transfer()
    state_machine(StateMachine, accounts[0:3], frames_crowdsale, settings=settings)
