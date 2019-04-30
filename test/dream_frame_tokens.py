from util import reverts, call_function, test_deploy, wrong

ERC165_INTERFACE = {'name': 'ERC165', 'id': '0x01ffc9a7'}
ERC721_INTERFACE = {'name': 'ERC721', 'id': '0x80ac58cd'}
ERC721_ENUMERABLE_INTERFACE = {'name': 'ERC721Enumerable', 'id': '0x780e9d63'}
ERC721_METADATA_INTERFACE = {'name': 'ERC721Metadata', 'id': '0x5b5e139f'}


def test_implements_interfaces(contract, interfaces):
    print('check that contract implements interfaces: {}: '
          .format([interface['name'] for interface in interfaces]), end='')

    implements_zero_id = call_function(contract, 'supportsInterface', ['0xffffffff'])
    assert not implements_zero_id, 'should not implement 0xffffffff'

    for interface in interfaces:
        implements = call_function(contract, 'supportsInterface', [interface['id']])
        assert implements, 'does not implement interface: {}'.format(interface['name'])

    print('SUCCESS')


def test_initialized_correctly(contract, name, symbol):
    print('check that contract is initialized correctly: ', end='')

    got_name = call_function(contract, 'name')
    assert got_name == name, wrong('name', got_name, name)

    got_symbol = call_function(contract, 'symbol')
    assert got_symbol == symbol, wrong('symbol', got_symbol, symbol)

    total_supply = call_function(contract, 'totalSupply')
    assert total_supply == 0, wrong('initial supply', 0, total_supply)

    for token_number in [0, 1, 2, 5, 10, 25, 50]:
        assert reverts(call_function, [contract, 'tokenByIndex', [token_number]]), \
            'should not be able to access token #{}'.format(token_number)

    print('SUCCESS')


def test(w3, accounts, contract_path, contract_name):
    owner = accounts[0]
    name = 'Dream Frame Token #1'
    symbol = 'DFT1'
    interfaces = [
        ERC165_INTERFACE,
        ERC721_INTERFACE,
        ERC721_ENUMERABLE_INTERFACE,
        ERC721_METADATA_INTERFACE
    ]

    dft = test_deploy(w3, owner, contract_path, contract_name, [name, symbol])
    test_initialized_correctly(dft, name, symbol)
    test_implements_interfaces(dft, interfaces)


def get_deployed(w3, accounts, contract_path, contract_name):
    owner = accounts[1]
    name = 'Dream Frame Token #1'
    symbol = 'DFT1'

    dft = test_deploy(w3, owner, contract_path, contract_name, [name, symbol])
    return dft
