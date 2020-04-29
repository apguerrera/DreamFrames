from brownie.project import compiler


def main():
    contract_sources = {'path': "./contracts/DreamFrames/DreamFramesCrowdsale.sol"}
    json = compiler.generate_input_json(contract_sources)
    print(json)