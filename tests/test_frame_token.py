from brownie import accounts, web3, Wei, reverts
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract

ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'

# reset the chain after every test case
@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_init_frame_token(frame_token):
    assert frame_token.name() == 'Dream Frame Token'
    assert frame_token.symbol() == 'DFT'
    assert frame_token.totalSupply() == '1000 ether'
    assert frame_token.balanceOf(accounts[0]) == '1000 ether'

######################################
# Owned
######################################

def test_frame_token_owned(frame_token):
    assert frame_token.owner({'from': accounts[0]}) == accounts[0]

def test_frame_token_transferOwnership(frame_token):
    tx = frame_token.transferOwnership(accounts[2], {'from': accounts[0]})
    tx = frame_token.acceptOwnership( {'from': accounts[2]})

    assert 'OwnershipTransferred' in tx.events
    assert tx.events['OwnershipTransferred'] == {'from': accounts[0], 'to': accounts[2]}
    with reverts():
        frame_token.transferOwnership(accounts[2], {'from': accounts[0]})

######################################
# ERC20 Tests
######################################

def test_erc20_transfer(frame_token):
    tx = frame_token.transfer(accounts[2], '2 ether', {'from': accounts[0]})

    assert frame_token.balanceOf(accounts[0]) == '998 ether'
    assert frame_token.balanceOf(accounts[2]) == '2 ether'

    assert 'Transfer' in tx.events
    assert tx.events['Transfer'] == {'from': accounts[0], 'to': accounts[2], 'tokens': '2 ether'}


def test_erc20_transfer_not_enough_funds(frame_token):
    with reverts():
        frame_token.transfer(accounts[2], '1001 ether', {'from': accounts[0]})


def test_erc20_approve(frame_token):
    tx = frame_token.approve(accounts[2], '5 ether', {'from': accounts[0]})

    assert frame_token.allowance(accounts[0], accounts[2]) == '5 ether'

    assert 'Approval' in tx.events
    assert tx.events['Approval'] == {'tokenOwner': accounts[0], 'spender': accounts[2], 'tokens': '5 ether'}


def test_erc20_transfer_from(frame_token):
    frame_token.approve(accounts[2], '10 ether', {'from': accounts[0]})

    tx = frame_token.transferFrom(accounts[0], accounts[3], '5 ether', {'from': accounts[2]})

    assert frame_token.balanceOf(accounts[0]) == '995 ether'
    assert frame_token.balanceOf(accounts[3]) == '5 ether'

    assert 'Transfer' in tx.events
    assert tx.events['Transfer'] == {'from': accounts[0], 'to': accounts[3], 'tokens': '5 ether'}


def test_erc20_transfer_from_not_enough_funds(frame_token):
    frame_token.approve(accounts[2], '1001 ether', {'from': accounts[0]})
    with reverts():
        frame_token.transferFrom(accounts[0], accounts[3], '1001 ether', {'from': accounts[2]})



######################################
# Minting and management
######################################


def test_btts_minter(frame_token):
    tx = frame_token.setMinter(accounts[2],{'from': accounts[0]})
    assert 'MinterUpdated' in tx.events

    tx = frame_token.setMinter(accounts[3],{'from': accounts[0]})
    assert 'MinterUpdated' in tx.events
    assert tx.events['MinterUpdated'] == {'from': accounts[2], 'to': accounts[3]}


def test_btts_disableMinting(frame_token):
    tx = frame_token.setMinter(accounts[2],{'from': accounts[0]})
    assert 'MinterUpdated' in tx.events
    tx = frame_token.mint(accounts[3], '5 ether', False, {'from': accounts[0]})
    assert frame_token.balanceOf(accounts[3]) == '5 ether'

    tx = frame_token.disableMinting({'from': accounts[2]})
    assert 'MintingDisabled' in tx.events
    assert frame_token.mintable() == False

    with reverts():
        tx = frame_token.mint(accounts[3], '5 ether', False, {'from': accounts[0]})

    assert frame_token.balanceOf(accounts[3]) == '5 ether'





    # function minter() public view returns (address) {
    #     return data.minter;
    # }
    # function setMinter(address _minter) public {
    #     data.setMinter(_minter);
    # }
    # function mint(address tokenOwner, uint tokens, bool lockAccount) public returns (bool success) {
    #     return data.mint(tokenOwner, tokens, lockAccount);
    # }
    # function accountLocked(address tokenOwner) public view returns (bool) {
    #     return data.accountLocked[tokenOwner];
    # }
    # function unlockAccount(address tokenOwner) public {
    #     data.unlockAccount(tokenOwner);
    # }
    # function mintable() public view returns (bool) {
    #     return data.mintable;
    # }
    # function transferable() public view returns (bool) {
    #     return data.transferable;
    # }
    # function disableMinting() public {
    #     data.disableMinting();
    # }
    # function enableTransfers() public {
    #     data.enableTransfers();
    # }