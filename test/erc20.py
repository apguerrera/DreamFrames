from util import transact_function, call_function, wrong, reverts, check_event, ZERO_ADDRESS, test_deploy_library


def test_case(func):
    def test_func(*args, **kwargs):
        try:
            func(*args, **kwargs)
        except Exception as e:
            print('ERROR: {}'.format(e))
            pass

    return test_func


@test_case
def test_initialized_correctly(contract, owner, name, symbol, decimals, initial_supply):
    print('check that contract is initialized correctly: ', end='')

    got_owner = call_function(contract, 'owner')
    assert got_owner == owner, wrong('owner', got_owner, owner)

    got_name = call_function(contract, 'name')
    assert got_name == name, wrong('name', got_name, name)

    got_symbol = call_function(contract, 'symbol')
    assert got_symbol == symbol, wrong('symbol', got_symbol, symbol)

    got_decimals = call_function(contract, 'decimals')
    assert got_decimals == decimals, wrong('decimals', got_decimals, decimals)

    total_supply = call_function(contract, 'totalSupply')
    assert total_supply == initial_supply, wrong('initial supply', total_supply, initial_supply)

    print('SUCCESS')


@test_case
def test_initial_balances(contract, accounts):
    print('check that balances are initialized correctly: ', end='')

    owner = call_function(contract, 'owner')
    owner_balance = call_function(contract, 'balanceOf', [owner])
    total_supply = call_function(contract, 'totalSupply')

    assert owner_balance == total_supply, wrong('balance of owner', owner_balance, total_supply)

    for address in accounts:
        if address != owner:
            balance = call_function(contract, 'balanceOf', [address])
            assert balance == 0, wrong('balance of {}'.format(address), balance, 0)

    print('SUCCESS')


@test_case
def test_initial_allowances(contract, accounts):
    print('check that allowances are initialized correctly: ', end='')

    owner = call_function(contract, 'owner')
    for address in accounts:
        allowance = call_function(contract, 'allowance', [owner, address])
        assert allowance == 0, wrong('owner allowance for {}'.format(address), allowance, 0)

        allowance = call_function(contract, 'allowance', [address, owner])
        assert allowance == 0, wrong('{} allowance for owner'.format(address), allowance, 0)

    for sender in accounts:
        for receiver in accounts:
            allowance = call_function(contract, 'allowance', [sender, receiver])
            assert allowance == 0, wrong('{} allowance for {}'.format(sender, receiver), allowance, 0)

    print('SUCCESS')


def check_transfer(contract, sender, receiver, amount):
    sender_balance = call_function(contract, 'balanceOf', [sender])
    receiver_balance = call_function(contract, 'balanceOf', [receiver])

    tx_hash = transact_function(sender, contract, 'transfer', [receiver, amount])
    contract.web3.eth.waitForTransactionReceipt(tx_hash)

    new_sender_balance = call_function(contract, 'balanceOf', [sender])
    new_receiver_balance = call_function(contract, 'balanceOf', [receiver])

    # check that balances are correct after transfer
    if sender != receiver:
        assert new_sender_balance == sender_balance - amount, \
            wrong('balance of sender {} after transfer', new_sender_balance, sender_balance - amount)

        assert new_receiver_balance == receiver_balance + amount, \
            wrong('balance of receiver {} after transfer'.format(receiver), new_receiver_balance,
                  receiver_balance + amount)
    else:
        assert sender_balance == new_sender_balance, \
            wrong('balance of address {} after transferring to itself'.format(sender), new_sender_balance,
                  sender_balance)

    # check that Transfer event is emitted correctly
    check_event(contract, tx_hash, 'Transfer', {'from': sender, 'to': receiver, 'tokens': amount})


@test_case
def test_transfer(contract, accounts):
    print('check that tokens are transferred correctly: ', end='')

    senders = accounts[:3]
    receivers = accounts[2:5]
    amount = 10
    for sender in senders:
        for receiver in receivers:
            check_transfer(contract, sender, receiver, amount)

            # should not send more than balance
            sender_balance = call_function(contract, 'balanceOf', [sender])
            assert reverts(transact_function, [sender, contract, 'transfer', [receiver, sender_balance + 1]]), \
                'owner should not be able to send more tokens than his balance'

            # should be able to send 0 tokens
            check_transfer(contract, sender, receiver, 0)

            # account should be able to transfer to itself
            check_transfer(contract, sender, sender, amount)

            # account should not be able to transfer tokens to zero address -> Not for BTTS token
            #assert reverts(transact_function, [sender, contract, 'transfer', [ZERO_ADDRESS, 1]]), \
            #        'transfer to 0x0 should revert'

    print('SUCCESS')


def check_approve(contract, approver, spender, amount):
    tx_hash = transact_function(approver, contract, 'approve', [spender, amount])
    contract.web3.eth.waitForTransactionReceipt(tx_hash)

    allowance = call_function(contract, 'allowance', [approver, spender])
    assert allowance == amount, wrong('{} allowance for {}'.format(approver, spender), allowance, amount)

    # check that Approval event is emitted correctly
    check_event(contract, tx_hash, 'Approval', {'tokenOwner': approver, 'spender': spender, 'tokens': amount})


@test_case
def test_approve(contract, approvers, spenders):
    print('check that approval works correctly: ', end='')

    amount = 84
    for approver in approvers:
        for spender in spenders:
            check_approve(contract, approver, spender, amount)

    print('SUCCESS')


def check_adjust_approval(contract, approver, spender, amount):
    allowance = call_function(contract, 'allowance', [approver, spender])

    if amount >= 0:
        function_name = 'increaseApproval'
    else:
        function_name = 'decreaseApproval'

    tx_hash = transact_function(approver, contract, function_name, [spender, abs(amount)])
    contract.web3.eth.waitForTransactionReceipt(tx_hash)

    new_allowance = call_function(contract, 'allowance', [approver, spender])
    assert new_allowance == allowance + amount, wrong('{} allowance for {}'.format(approver, spender), allowance,
                                                      amount)

    # check that Approval event is emitted correctly
    check_event(contract, tx_hash, 'Approval', {'tokenOwner': approver, 'spender': spender, 'tokens': new_allowance})


@test_case
def test_increase_approval(contract, approvers, spenders):
    print('check that increaseApproval works correctly: ', end='')

    amount = 5
    for approver in approvers:
        for spender in spenders:
            check_adjust_approval(contract, approver, spender, amount)

    print('SUCCESS')


@test_case
def test_decrease_approval(contract, approvers, spenders):
    print('check that decreaseApproval works correctly: ', end='')

    amount = -5
    for approver in approvers:
        for spender in spenders:
            check_adjust_approval(contract, approver, spender, amount)

    print('SUCCESS')


def check_transfer_from(contract, approver, spender, receiver, amount):
    approver_balance = call_function(contract, 'balanceOf', [approver])
    receiver_balance = call_function(contract, 'balanceOf', [receiver])
    spender_balance = call_function(contract, 'balanceOf', [spender])
    allowance = call_function(contract, 'allowance', [approver, spender])

    tx_hash = transact_function(spender, contract, 'transferFrom', [approver, receiver, amount])
    contract.web3.eth.waitForTransactionReceipt(tx_hash)

    new_approver_balance = call_function(contract, 'balanceOf', [approver])
    new_receiver_balance = call_function(contract, 'balanceOf', [receiver])
    new_spender_balance = call_function(contract, 'balanceOf', [spender])
    new_allowance = call_function(contract, 'allowance', [approver, spender])

    assert new_allowance == allowance - amount, \
        wrong('{} allowance to {}'.format(approver, spender), new_allowance, allowance - amount)

    # check that balances are correct after transferFrom
    if approver != receiver:
        assert new_approver_balance == approver_balance - amount, \
            wrong('balance of approver {} after transfer', new_approver_balance, approver_balance - amount)

        assert new_receiver_balance == receiver_balance + amount, \
            wrong('balance of receiver {} after transfer'.format(receiver), new_receiver_balance,
                  receiver_balance + amount)
    else:
        assert new_approver_balance == approver_balance, \
            wrong('balance of approver {} after transfer to itself'.format(approver), new_approver_balance,
                  approver_balance)

    if spender != receiver and spender != spender:
        assert new_spender_balance == spender_balance, \
            wrong('balance of spender {} after transfer', new_spender_balance, spender_balance)

    # check that Transfer event is emitted correctly
    check_event(contract, tx_hash, 'Transfer', {'from': approver, 'to': receiver, 'tokens': amount})


@test_case
def test_transfer_from(contract, accounts, approvers, spenders):
    print('check that transferFrom works correctly: ')

    receivers = accounts[3:4]
    amount = 1
    for approver in approvers:
        for spender in spenders:
            for receiver in receivers:
                print("Approver: {} Spender: {} Receiver: {}".format(approver, spender, receiver))
                check_transfer_from(contract, approver, spender, receiver, amount)

                # should not send more than balance of approver
                approver_balance = call_function(contract, 'balanceOf', [approver])
                assert reverts(transact_function,
                               [spender, contract, 'transferFrom', [approver, receiver, approver_balance + 1]]), \
                    'spender should not be able to send more tokens than balance of approver'

                # should not send more than allowance
                allowance = call_function(contract, 'allowance', [approver, spender])
                assert reverts(transact_function,
                               [spender, contract, 'transferFrom', [approver, receiver, allowance + 1]]), \
                    'spender should not be able to send more tokens than allowance'

                # spender should not be able to transfer tokens to zero address
                assert reverts(transact_function, [spender, contract, 'transferFrom', [approver, ZERO_ADDRESS, 1]]), \
                    'transferFrom to 0x0 should revert'

    print('SUCCESS')


@test_case
def test_disable_transfers(contract, accounts, approvers, spenders):
    print('check that disabling transfers works correctly: ', end='')

    # non owner account should not be able to enable transfers
    owner = call_function(contract, 'owner')
    not_owners = [account for account in accounts if account != owner]
    for account in not_owners:
        assert reverts(transact_function, [account, contract, 'disableTransfers']), \
            'non owner account {} should not be able to disable transfers'.format(account)

    # owner should be able to enable transfers
    tx_hash = transact_function(owner, contract, 'disableTransfers')
    check_event(contract, tx_hash, 'TransfersDisabled')

    # check that transfer reverts
    senders = accounts[:2]
    receivers = accounts[1:3]
    for sender in senders:
        for receiver in receivers:
            assert reverts(transact_function, [sender, contract, 'transfer', [receiver, 1]]), \
                '{} should not be able to transfer when transferring is disabled'.format(sender)

    # check that transferFrom reverts
    for approver in approvers:
        for spender in spenders:
            receiver = accounts[3]
            assert reverts(transact_function, [spender, contract, 'transferFrom', [approver, receiver, 1]])

    # check that triggering disableTransfers one more time fails
    assert reverts(transact_function, [owner, contract, 'disableTransfers']), \
        'owner should not be able to disable transfers when it is already disabled'

    print('SUCCESS')


@test_case
def test_enable_transfers(contract, accounts, approvers, spenders):
    print('check that enabling transfers works correctly: ', end='')

    # non owner account should not be able to enable transfers
    owner = call_function(contract, 'owner')
    not_owners = [account for account in accounts if account != owner]
    for account in not_owners:
        assert reverts(transact_function, [account, contract, 'enableTransfers']), \
            'non owner account {} should not be able to enable transfers'.format(account)

    # owner should be able to enable transfers
    tx_hash = transact_function(owner, contract, 'enableTransfers')
    check_event(contract, tx_hash, 'TransfersEnabled')

    # check that transfer works after enabling transfers
    senders = accounts[:2]
    receivers = accounts[1:3]
    for sender in senders:
        for receiver in receivers:
            check_transfer(contract, sender, receiver, 1)

    # check that transferFrom works after enabling transfers
    for approver in approvers:
        for spender in spenders:
            receiver = accounts[3]
            check_transfer_from(contract, approver, spender, receiver, 1)

    # check that triggering enableTransfers one more time fails
    assert reverts(transact_function, [owner, contract, 'enableTransfers']), \
        'owner should not be able to enable transfers when it is already enabled'

    print('SUCCESS')


@test_case
def fund_accounts(contract, accounts, amount):
    print('funding accounts: ', end='')

    owner = call_function(contract, 'owner')
    for account in accounts:
        check_transfer(contract, owner, account, amount)

    print('SUCCESS')


def test(w3, accounts, contract_path, contract_name, name, symbol, decimals,
         initial_supply, owner, mintable, transferable, btts_library_address):
    token_contract = test_deploy_library(w3, owner, contract_path, contract_name, btts_library_address,
                                         [owner, symbol, name, decimals, initial_supply, mintable, transferable])

    test_initialized_correctly(token_contract, owner, name, symbol, decimals, initial_supply)
    test_initial_balances(token_contract, accounts)
    test_initial_allowances(token_contract, accounts)

    fund_accounts(token_contract, accounts, 100)
    test_transfer(token_contract, accounts)

    approvers = accounts[:2]
    spenders = accounts[1:3]
    test_approve(token_contract, approvers, spenders)

    # test_increase_approval(token_contract, approvers, spenders)
    # test_decrease_approval(token_contract, approvers, spenders)
    test_transfer_from(token_contract, accounts, approvers, spenders)

    # test_disable_transfers(token_contract, accounts, approvers, spenders)
    if not transferable:
        test_enable_transfers(token_contract, accounts, approvers, spenders)

    return token_contract


def test_white_list(w3, accounts, contract_path, contract_name, name, symbol, decimals,
         initial_supply, owner, mintable, transferable, btts_library_address, white_list):
    token_contract = test_deploy_library(w3, owner, contract_path, contract_name, btts_library_address,
                                         [owner, symbol, name, decimals, initial_supply, mintable, transferable, white_list])

    test_initialized_correctly(token_contract, owner, name, symbol, decimals, initial_supply)
    test_initial_balances(token_contract, accounts)
    test_initial_allowances(token_contract, accounts)

    fund_accounts(token_contract, accounts, 1000000)
    test_transfer(token_contract, accounts)

    approvers = accounts[:2]
    spenders = accounts[1:3]
    test_approve(token_contract, approvers, spenders)

    # test_increase_approval(token_contract, approvers, spenders)
    # test_decrease_approval(token_contract, approvers, spenders)
    test_transfer_from(token_contract, accounts, approvers, spenders)

    # test_disable_transfers(token_contract, accounts, approvers, spenders)
    if not transferable:
        test_enable_transfers(token_contract, accounts, approvers, spenders)

    return token_contract
