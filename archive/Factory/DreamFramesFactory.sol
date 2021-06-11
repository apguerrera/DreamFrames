pragma solidity ^0.6.12;

import "../Shared/Operated.sol";
import "../DreamFramesToken/DreamFramesCrowdsale.sol";
// import "../DreamFramesToken/DreamFramesToken.sol";


contract ITokenFactory {
    function deployTokenContract(address owner, string memory symbol, string memory name, uint8 decimals, uint totalSupply, bool mintable, bool transferable) public  returns (address);
}


// ----------------------------------------------------------------------------
// House Factory
// ----------------------------------------------------------------------------
contract DreamFramesFactory is Operated {

    mapping(address => bool) _verify;
    address[] public deployedFanTokens;
    DreamFramesCrowdsale[] public deployedTokenCrowdsales;

    address public priceFeed;
    ITokenFactory public tokenFactory;

    event PriceFeedUpdated(address indexed oldPriceFeed, address indexed newPriceFeed);
    event TokenFactoryUpdated(address indexed oldTokenFactory, address indexed newTokenFactory);
    event RoyaltyTokenFactoryUpdated(address indexed oldRoyaltyTokenFactory, address indexed newRoyaltyTokenFactory);

    // AG - to be updated
    // event TokenContractsDeployed(address indexed movie, string movieName, address indexed token, string tokenSymbol, string tokenName, uint8 tokenDecimals, address indexed housemateName, uint tokensForNewHousemates);
    event CrowdsaleContractsDeployed(address indexed token, address wallet);

    constructor() public {
        super.initOperated(msg.sender);
    }

    // Setter functions
    function setTokenFactory(address _tokenFactory) public onlyOwner {
        require(_tokenFactory != address(0));
        emit TokenFactoryUpdated(address(tokenFactory), _tokenFactory);
        tokenFactory = ITokenFactory(_tokenFactory);
    }

    function setPriceFeed(address _priceFeed) public onlyOwner {
        require(_priceFeed != address(0));
        emit WhiteListUpdated(priceFeed, _priceFeed);
        priceFeed = _priceFeed;
    }

    // Deployment functions
    function deployTokenContract(
        address owner,
        string memory symbol,
        string memory name,
        uint8 decimals,
        uint256 totalSupply,
        bool mintable,
        bool transferable
    ) public onlyOwner returns (address token) {
        token = tokenFactory.deployTokenContract(
                                    owner,
                                    symbol,
                                    name,
                                    decimals,
                                    totalSupply,
                                    mintable,
                                    transferable
                                );
        _verify[address(token)] = true;
        deployedFanTokens.push(token);

    }


    function deployCrowdsaleContracts(
        address token,
        address payable wallet,
        uint256 startDate,
        uint256 endDate,
        uint256 minFrames,
        uint256 maxFrames,
        uint256 maxRoyaltyFrames,
        uint256 producerFrames,
        uint256 frameUsd,
        uint256 bonusOffList,
        uint256 hardCapUsd,
        uint256 softCapUsd
    ) public onlyOwner returns (DreamFramesCrowdsale crowdsale  ) {
        // Deploy Crowdsale contract
        crowdsale = new DreamFramesCrowdsale();
        crowdsale.init(token,priceFeed,wallet, startDate, endDate, minFrames, maxFrames, producerFrames, frameUsd, bonusOffList, hardCapUsd, softCapUsd);

        _verify[address(crowdsale)] = true;
        deployedTokenCrowdsales.push(crowdsale);      

        emit CrowdsaleContractsDeployed( address(token), wallet);
    }

    // Counter functions
    function verify(address addr) public view returns (bool valid) {
        valid = _verify[addr];
    }
    function numberOfDeployedFanTokens() public view returns (uint) {
        return deployedFanTokens.length;
    }

    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
    receive() external payable {
        revert();
    }
}
