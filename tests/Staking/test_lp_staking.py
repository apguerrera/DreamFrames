from brownie import accounts, web3, Wei, chain, reverts
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract
from settings import *
import math 

@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


# This is for a fixed dummy token, needs to be LP tokens
@pytest.fixture(scope='function')
def transfer_lp_tokens_to_multiple_accounts(lp_token):
  transfer_amount = 50 * TENPOW18
  transfer_to = accounts[4]
  owner = accounts[0]
  lp_token.transfer(transfer_to,transfer_amount,{"from": owner})

  transfer_amount = 50 * TENPOW18
  transfer_to = accounts[6]
  lp_token.transfer(transfer_to,transfer_amount,{"from": owner})


@pytest.fixture(scope='module', autouse=True)
def rewards_contract(GazeRewards, staking_rewards):
    rewards_contract = GazeRewards.at(staking_rewards.rewardsContract())
    return rewards_contract

def stake(staking_rewards, staker, staking_amount):
    staking_rewards.stake(staking_amount, {"from": staker})
    staker_info = staking_rewards.stakers(staker)
    assert staker_info[0] == staking_amount


def test_zap(staking_rewards, lp_token, rewards_contract, weth_token, gaze_coin):
    staker = accounts[5]
    before_stake_lp_balance = staking_rewards.getStakedBalance(staker)
    
    eth_amount = 1 * TENPOW18
    staking_rewards.zapEth({"from":staker, 'value': eth_amount})
    after_stake_lp_balance = staking_rewards.getStakedBalance(staker)
    total_eth_staked = staking_rewards.stakedEthTotal()
    assert after_stake_lp_balance > before_stake_lp_balance
    
    chain.sleep(ONE_WEEK*2)
    
    # Unstaking

    unstaking_amount = staking_rewards.stakers(staker)[0]
    
    # updating staker info
    staking_rewards.updateReward(staker, {'from': staker}) 
    before_stake_rewards_balance = gaze_coin.balanceOf(staker)
    unclaimed_rewards_before = staking_rewards.unclaimedRewards(staker)
    
    tx = staking_rewards.unstake(unstaking_amount, {"from":staker})    
    after_stake_rewards_balance = gaze_coin.balanceOf(staker)

    assert "Unstaked" in tx.events
    assert round((after_stake_rewards_balance - before_stake_rewards_balance) / TENPOW18) == round(unclaimed_rewards_before / TENPOW18)
    assert staking_rewards.unclaimedRewards(staker) == 0

def test_stake(staking_rewards, lp_token, rewards_contract, gaze_coin):
    staker = accounts[5]
    staking_amount = 100*TENPOW18

    lp_token.transfer(staker, staking_amount, {'from': accounts[0]})
    lp_token.approve(staking_rewards, staking_amount, {'from': staker})
    stake(staking_rewards, staker, staking_amount)

    chain.sleep(ONE_WEEK*2)

    # updating staker info
    staking_rewards.updateReward(staker, {'from': staker})
    print("LP Total Staked:", staking_rewards.stakedLPTotal())

    # Claiming reward
    unclaimed_rewards_before = staking_rewards.unclaimedRewards(staker)
    before_staker_rewards_balance = gaze_coin.balanceOf(staker)
    assert unclaimed_rewards_before > 0

    print("unclaimed amount", unclaimed_rewards_before)

    tx = staking_rewards.claimReward(staker, {'from': staker})
    staker_info = staking_rewards.stakers(staker)
    after_staker_rewards_balance = gaze_coin.balanceOf(staker)

    assert "RewardPaid" in tx.events
    assert staking_rewards.unclaimedRewards(staker) == 0
    assert round(unclaimed_rewards_before / TENPOW18) == round(staker_info[2] / TENPOW18)
    assert round((before_staker_rewards_balance+unclaimed_rewards_before)/TENPOW18) == round(after_staker_rewards_balance/TENPOW18)


def test_unstake(staking_rewards, lp_token, rewards_contract, gaze_coin):
    staker = accounts[5]
    staking_amount = 50*TENPOW18
    lp_token.transfer(staker, staking_amount, {'from': accounts[0]})
    lp_token.approve(staking_rewards, staking_amount, {'from': staker})

    stake(staking_rewards, staker, staking_amount)

    chain.sleep(ONE_WEEK*2)

    # updating staker info
    staking_rewards.updateReward(staker, {'from': staker})

    unclaimed_rewards = staking_rewards.unclaimedRewards(staker)

    tx = staking_rewards.unstake(staking_amount, {'from': staker})
    staker_info = staking_rewards.stakers(staker)

    assert "Unstaked" in tx.events
    assert round(unclaimed_rewards / TENPOW18) == round(gaze_coin.balanceOf(staker) / TENPOW18)
    assert staker_info[0] == 0
    assert staker_info[1] == 0
    assert staker_info[2] == 0
    assert staker_info[3] == 0


def test_multiple_staking_and_unstaking(lp_token, staking_rewards, rewards_contract, gaze_coin):
    lp_token_owner = accounts[0]
    for i in range(2, 7):
        transfer_amount = 50 * TENPOW18
        transfer_to = accounts[i]

        lp_token.transfer(transfer_to, transfer_amount, {"from": lp_token_owner})
        
    # Staking
    for i in range(2, 7):
        staker = accounts[i]
        staking_amount = 50 * TENPOW18

        lp_token.approve(staking_rewards,staking_amount,{"from": staker})

        before_stake_lp_balance = lp_token.balanceOf(staker)

        stake(staking_rewards, staker, staking_amount)

        after_stake_lp_balance = lp_token.balanceOf(staker)

        assert before_stake_lp_balance - after_stake_lp_balance == staking_amount

    chain.sleep(ONE_WEEK*2)

    # Unstaking 1/2
    week_1_rewards = 70000 * TENPOW18
    participants = 5
    first_week_rewards_per_staker = week_1_rewards / participants
    for i in range(2, 7):
        staker = accounts[i]
        unstaking_amount = 25 * TENPOW18

        before_unstake_rewards_balance = gaze_coin.balanceOf(staker)

        staking_rewards.unstake(unstaking_amount, {"from":staker})

        after_unstake_rewards_balance = gaze_coin.balanceOf(staker)

        assert round((after_unstake_rewards_balance - before_unstake_rewards_balance) / TENPOW18) == round(first_week_rewards_per_staker/TENPOW18)

    chain.sleep(ONE_WEEK*2)

    # Unstaking 2/2
    week_2_rewards = 60000 * TENPOW18
    second_week_rewards_per_staker = week_2_rewards / participants
    for i in range(2, 7):
        staker = accounts[i]
        unstaking_amount = 25 * TENPOW18

        before_stake_rewards_balance = gaze_coin.balanceOf(staker)

        staking_rewards.unstake(unstaking_amount, {"from": staker})

        after_stake_rewards_balance = gaze_coin.balanceOf(staker)

        assert round((after_stake_rewards_balance -  before_stake_rewards_balance) / TENPOW18) == round(second_week_rewards_per_staker / TENPOW18)


def test_staking_and_then_complete_unstaking(lp_token, staking_rewards, gaze_coin):
    staker = accounts[5]
    staking_amount = 25 * TENPOW18

    lp_token.transfer(staker, staking_amount, {'from': accounts[0]})
    lp_token.approve(staking_rewards, staking_amount,{"from": staker})
    before_stake_lp_balance = lp_token.balanceOf(staker)

    staking_rewards.stake(staking_amount, {"from": staker})
    
    after_stake_lp_balance = lp_token.balanceOf(staker)

    assert before_stake_lp_balance - after_stake_lp_balance  == staking_amount
    chain.sleep(ONE_WEEK*2)
    unstaking_amount = 25 * TENPOW18
    before_stake_rewards_balance = gaze_coin.balanceOf(staker)
    tx = staking_rewards.unstake(unstaking_amount, {"from":staker})
   
    after_stake_rewards_balance = gaze_coin.balanceOf(staker)

    first_week_rewards_per_staker = 70000 * TENPOW18
    assert round((after_stake_rewards_balance -  before_stake_rewards_balance) / TENPOW18) == round(first_week_rewards_per_staker/ TENPOW18)
    assert staking_rewards.stakers(staker)[0] == 0
    assert staking_rewards.stakers(staker)[1] == 0


def test_emergency_unstake(lp_token, staking_rewards, gaze_coin):
    staker = accounts[5]
    staking_amount = 50* TENPOW18

    lp_token.transfer(staker, staking_amount, {'from': accounts[0]})
    lp_token.approve(staking_rewards,staking_amount,{"from": staker})
    before_stake_lp_balance = lp_token.balanceOf(staker)
    staking_rewards.stake(staking_amount, {"from": staker})
    after_stake_lp_balance = lp_token.balanceOf(staker)
    assert before_stake_lp_balance - after_stake_lp_balance  == staking_amount
    
    chain.sleep(ONE_WEEK*2)

    before_unstake_lp_balance = lp_token.balanceOf(staker)
    staking_rewards.emergencyUnstake({"from":staker})
    after_unstake_lp_balance = lp_token.balanceOf(staker)
    assert after_unstake_lp_balance - before_unstake_lp_balance == staking_amount 
 
def test_staking_12_weeks(lp_token, staking_rewards, rewards_contract, gaze_coin):
    staker = accounts[5]
    staking_amount = 50* TENPOW18

    lp_token.transfer(staker, staking_amount, {'from': accounts[0]})
    lp_token.approve(staking_rewards,staking_amount,{"from": staker})

    stake(staking_rewards, staker, staking_amount)

    chain.sleep(ONE_WEEK*12)

    tx = staking_rewards.claimReward(staker, {'from': staker})
    staker_info = staking_rewards.stakers(staker)
    assert round(gaze_coin.balanceOf(staker) / TENPOW18) + 5 >= 317000


def test_unstaking_without_balance(staking_rewards, lp_token):
    account = accounts[2]
    assert staking_rewards.stakers(account)[0] == 0

    with reverts("GazeLPStaking._unstake: Sender must have staked tokens"):
        staking_rewards.unstake(1*TENPOW18)
