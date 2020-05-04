#!/usr/bin/python3

import brownie
from brownie.test import strategy


class StateMachine:

    value = strategy('uint256', max_value="1 ether")
    address = strategy('address')

    def __init__(cls, accounts, contract):
        # deploy the contract at the start of the test
        cls.accounts = accounts
        cls.contract = contract

    def setup(self):
        # zero the deposit amounts at the start of each test run
        self.deposits = {i: 0 for i in self.accounts}
        self.total = 0

    def rule_deposit(self, address, value):
        # make a deposit and adjust the local record
        self.contract.depositDividends({'from': address, 'value': value})
        self.deposits[address] += value
        self.total += value

    def rule_withdraw(self, address, value):
        if self.deposits[address] >= value:
            # make a withdrawal and adjust the local record
            self.contract.withdrawDividends({'from': address})
            self.deposits[address] -= value
            self.total -= value

        else:
            # attempting to withdraw beyond your balance should revert
            with brownie.reverts():
                self.contract.withdrawDividends({'from': address})

    def invariant(self):
        # compare the contract deposit amounts with the local record
        for address, amount in self.deposits.items():
            assert self.contract.dividendsOwing(address) == amount


def test_dividends(royalty_token, accounts, state_machine):
    settings = {"stateful_step_count": 20, "max_examples": 20}
    state_machine(StateMachine, accounts, royalty_token, settings=settings)
