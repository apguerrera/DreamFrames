pragma solidity ^0.5.4;

import "../Shared/Operated.sol";
import "../DreamFramesToken/DreamFramesCrowdsale.sol";
import "../RoyaltyToken/RoyaltyTokenCrowdsale.sol";
// import "../DreamFramesToken/DreamFramesToken.sol";
// import "../RoyaltyToken/DividendToken.sol";


contract ITokenFactory {
    function deployTokenContract(address owner, string memory symbol, string memory name, uint8 decimals, uint totalSupply, bool mintable, bool transferable) public  returns (address);
}

contract IRoyaltyTokenFactory {
    function deployRoyaltyTokenContract(address owner, string memory symbol, string memory name, uint8 decimals, uint totalSupply, bool mintable, bool transferable, address whitelist) public  returns (address);
}


// ----------------------------------------------------------------------------
// House Factory
// ----------------------------------------------------------------------------
contract DreamFramesFactory is Operated {

    mapping(address => bool) _verify;
    address[] public deployedFanTokens;
    address[] public deployedRoyaltyTokens;
    DreamFramesCrowdsale[] public deployedTokenCrowdsales;
    DreamFramesRoyaltyCrowdsale[] public deployedRoyaltyCrowdsales;

    address public whiteList;
    address public priceFeed;
    ITokenFactory public tokenFactory;
    IRoyaltyTokenFactory public royaltyTokenFactory;

    event WhiteListUpdated(address indexed oldWhiteList, address indexed newWhiteList);
    event PriceFeedUpdated(address indexed oldPriceFeed, address indexed newPriceFeed);
    event TokenFactoryUpdated(address indexed oldTokenFactory, address indexed newTokenFactory);
    event RoyaltyTokenFactoryUpdated(address indexed oldRoyaltyTokenFactory, address indexed newRoyaltyTokenFactory);

    // AG - to be updated
    // event TokenContractsDeployed(address indexed movie, string movieName, address indexed token, string tokenSymbol, string tokenName, uint8 tokenDecimals, address indexed housemateName, uint tokensForNewHousemates);
    event CrowdsaleContractsDeployed( address indexed token, address indexed royaltyToken, address wallet);

    constructor() public {
        super.initOperated(msg.sender);
    }

    // Setter functions
    function setWhiteList(address _whiteList) public onlyOwner {
        require(_whiteList != address(0));
        emit WhiteListUpdated(whiteList, _whiteList);
        whiteList = _whiteList;
    }
    function setTokenFactory(address _tokenFactory) public onlyOwner {
        require(_tokenFactory != address(0));
        emit TokenFactoryUpdated(address(tokenFactory), _tokenFactory);
        tokenFactory = ITokenFactory(_tokenFactory);
    }
    function setRoyaltyTokenFactory(address _royaltyTokenFactory) public onlyOwner {
        require(_royaltyTokenFactory != address(0));
        emit RoyaltyTokenFactoryUpdated(address(royaltyTokenFactory), _royaltyTokenFactory);
        royaltyTokenFactory = IRoyaltyTokenFactory(_royaltyTokenFactory);
    }
    function setPriceFeed(address _priceFeed) public onlyOwner {
        require(_priceFeed != address(0));
        emit WhiteListUpdated(priceFeed, _priceFeed);
        priceFeed = _priceFeed;
    }

    // Deployment functions
    function deployTokenContract(
        address owner,
        string memory name,
        string memory  symbol,
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

    // Deployment functions
    function deployRoyaltyTokenContract(
        address _owner,
        string memory _symbol,
        string memory _name,
        uint8 _decimals,
        uint256 _totalSupply,
        bool _mintable,
        bool _transferable
    ) public onlyOwner returns (address royaltyToken) {
        royaltyToken = royaltyTokenFactory.deployRoyaltyTokenContract(
                                    _owner, 
                                    _symbol,
                                    _name,
                                    _decimals,
                                    _totalSupply,
                                    _mintable,
                                    _transferable,
                                    whiteList
                                );
        _verify[address(royaltyToken)] = true;
        deployedRoyaltyTokens.push(royaltyToken);

    }

    function deployCrowdsaleContracts(
        address royalty,
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
    ) public onlyOwner returns (DreamFramesCrowdsale crowdsale , DreamFramesRoyaltyCrowdsale royaltyCS ) {
        // Deploy Crowdsale contract
        crowdsale = new DreamFramesCrowdsale(token,royalty, priceFeed, whiteList);
        crowdsale.init(wallet, startDate, endDate, minFrames, maxFrames, producerFrames, frameUsd, bonusOffList, hardCapUsd, softCapUsd);
        // Deploy Royalty Crowdsale
        royaltyCS = new DreamFramesRoyaltyCrowdsale(wallet, address(crowdsale), startDate, endDate, maxRoyaltyFrames);
        // Set operators 
        royaltyCS.setFrameCrowdsaleContract(address(crowdsale));
        crowdsale.setRoyaltyCrowdsale(address(royaltyCS));

        _verify[address(crowdsale)] = true;
        deployedTokenCrowdsales.push(crowdsale);      
        _verify[address(royaltyCS)] = true;
        deployedRoyaltyCrowdsales.push(royaltyCS);
        emit CrowdsaleContractsDeployed(address(royalty), address(token), wallet);
    }

    // Counter functions
    function verify(address addr) public view returns (bool valid) {
        valid = _verify[addr];
    }
    function numberOfDeployedFanTokens() public view returns (uint) {
        return deployedFanTokens.length;
    }
    function numberOfDeployedRoyaltyTokens() public view returns (uint) {
        return deployedRoyaltyTokens.length;
    }
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
    function () external payable {
        revert();
    }
}
