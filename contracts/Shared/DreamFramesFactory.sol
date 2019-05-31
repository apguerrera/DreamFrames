
import "./Owned.sol";
import "../RoyaltyToken/RoyaltyTokenCrowdsale.sol";
import "../RoyaltyToken/DividendToken.sol";
import "../DreamFramesToken/DreamFramesCrowdsale.sol";
import "../DreamFramesToken/DreamFramesToken.sol";


// Initial draft. To be completed

// ----------------------------------------------------------------------------
// House Factory
// ----------------------------------------------------------------------------
contract DreamFramesFactory is Owned {

    mapping(address => bool) _verify;
    FanToken[] public deployedFanTokens;
    RoyaltyToken[] public deployedRoyaltyTokens;
    FanCrowdsale[] public deployedFanCrowdsales;
    RoyaltyCrowdsale[] public deployedRoyaltyCrowdsales;

    address public whiteList;
    address public priceFeed;

    event WhiteListUpdated(address indexed oldWhiteList, address indexed newWhiteList);
    event PriceFeedUpdated(address indexed oldPriceFeed, address indexed newPriceFeed);

    // AG - to be updated
    event TokenContractsDeployed(address indexed movie, string movieName, address indexed token, string tokenSymbol, string tokenName, uint8 tokenDecimals, address indexed housemateName, uint tokensForNewHousemates);
    event CrowdsaleContractsDeployed(address indexed movie, string movieName, address indexed token, string tokenSymbol, string tokenName, uint8 tokenDecimals, address indexed housemateName, uint tokensForNewHousemates);

    // Setter functions
    function setWhiteList(address _whiteList) public onlyOwner {
        require(_whiteList != address(0));
        emit WhiteListUpdated(whiteList, _whiteList);
        whiteList = _whiteList;
    }
    function setPriceFeed(address _priceFeed) public onlyOwner {
        require(_priceFeed != address(0));
        emit WhiteListUpdated(priceFeed, _priceFeed);
        priceFeed = _priceFeed;
    }

    // Deployment functions
    function deployMovieContracts(
        string movieName,
        string tokenSymbol,
        string tokenName,
        uint8 tokenDecimals,
    ) public onlyOwner returns (RoyaltyToken royalty, FanToken token) {
        token = new FanToken();
        token.init(msg.sender);
        _verify[address(token)] = true;
        deployedFanTokens.push(token);
        royalty = new RoyaltyToken();
        royalty.init(msg.sender);
        // token.transferOwnershipImmediately(address(royalty));
        _verify[address(royalty)] = true;
        deployedRoyaltyTokens.push(royalty);
        emit TokenContractsDeployed(address(royalty), movieName, address(token), tokenSymbol, tokenName, tokenDecimals, msg.sender);
    }

    function deployCrowdsaleContracts(
          address royalty,
          address token
    ) public onlyOwner returns (RoyaltyCrowdsale royaltyCS, Crowdsale crowdsale) {
      // deploy Crowdsale contract
      crowdsale = new FanCrowdsale();
      crowdsale.init();
      _verify[address(crowdsale)] = true;
      deployedFanCrowdsales.push(crowdsale);
      // deploy Royalty Crowdsale
      royaltyCS = new RoyaltyCrowdsale();
      royaltyCS.init();
      _verify[address(royaltyCS)] = true;
      deployedRoyaltyCrowdsales.push(royaltyCS);
      emit CrowdsaleContractsDeployed(address(royalty), movieName, address(token), tokenSymbol, tokenName, tokenDecimals, msg.sender);
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
    function () public payable {
        revert();
    }
}
