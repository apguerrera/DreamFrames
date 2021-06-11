import subprocess

# run  `python scripts/flatten.py`

CONTRACT_DIR = "contracts/"

def flatten(mainsol, outputsol):
    pipe = subprocess.call("scripts/solidityFlattener.pl --contractsdir={} --mainsol={} --outputsol={} --verbose"
                           .format(CONTRACT_DIR, mainsol, outputsol), shell=True)
    print(pipe)

def flatten_contracts():
    flatten("DreamFrames/RoyaltyToken.sol", "flattened/RoyaltyToken_flattened.sol")
    flatten("DreamFrames/DreamFramesToken.sol", "flattened/DreamFramesToken_flattened.sol")
    flatten("DreamFrames/DreamFramesCrowdsale.sol", "flattened/DreamFramesCrowdsale_flattened.sol")
    flatten("DreamFrames/TokenFactory.sol", "flattened/TokenFactory_flattened.sol")
    flatten("DreamFrames/DreamChannelNFT.sol", "flattened/DreamChannelNFT_flattened.sol")

    flatten("Shared/CompoundPriceFeedAdaptor.sol", "flattened/CompoundPriceFeedAdaptor_flattened.sol")


flatten_contracts()