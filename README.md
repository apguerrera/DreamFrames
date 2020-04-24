# DreamFrameTokens

## Setup

Install needed Python modules: `python -m pip install -r requirements.txt`

## Compiling the contracts

Compile updated contracts: `brownie compile`

Compile all contracts (even not changed ones): `brownie compile --all`

## Running tests

Run tests: `brownie test`

Run tests in verbose mode: `brownie test -v`

Check code coverage: `brownie test --coverage`

Check available fixtures: `brownie --fixtures .`


## Brownie commands

Run script: `brownie run <script_path>`

Run console (very useful for debugging): `brownie console`

## Deploying DreamFrames Contracts 

Run script: `brownie run scripts/deploy_dream_frames_factory.py`

