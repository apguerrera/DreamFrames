// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package crowdsale

import (
	"math/big"
	"strings"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = abi.U256
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
)

// CrowdsaleABI is the input ABI used to generate the binding from.
const CrowdsaleABI = "[{\"constant\":true,\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"name\":\"_name\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"startDate\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_frameUsd\",\"type\":\"uint256\"}],\"name\":\"setFrameUsd\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"pctRemaining\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"hardCapEth\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"finalised\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_royaltyCrowdsaleAddres\",\"type\":\"address\"}],\"name\":\"setRoyaltyCrowdsale\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"whiteList\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_endDate\",\"type\":\"uint256\"}],\"name\":\"setEndDate\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_maxFrames\",\"type\":\"uint256\"}],\"name\":\"setMaxFrames\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"frameRushToken\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"ethUsdPriceFeed\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"wallet\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"ethUsd\",\"outputs\":[{\"name\":\"_rate\",\"type\":\"uint256\"},{\"name\":\"_live\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"softCapUsd\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"acceptOwnership\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnershipImmediately\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"hardCapUsd\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_startDate\",\"type\":\"uint256\"}],\"name\":\"setStartDate\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_bonusOffList\",\"type\":\"uint256\"}],\"name\":\"setBonusOffList\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"lockedAccountThresholdEth\",\"outputs\":[{\"name\":\"_amount\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"name\":\"_symbol\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"lockedAccountThresholdUsd\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"finalise\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"contributedEth\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"royaltyToken\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"endDate\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"frameEth\",\"outputs\":[{\"name\":\"_rate\",\"type\":\"uint256\"},{\"name\":\"_live\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"tokenOwner\",\"type\":\"address\"},{\"name\":\"frames\",\"type\":\"uint256\"},{\"name\":\"ethToTransfer\",\"type\":\"uint256\"}],\"name\":\"claimRoyaltyFrames\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"softCapEth\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"newOwner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"maxFrames\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"frameUsd\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"frameUsdWithBonus\",\"outputs\":[{\"name\":\"_rate\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_wallet\",\"type\":\"address\"}],\"name\":\"setWallet\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"framesSold\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"royaltyCrowdsaleAddress\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"bonusOffList\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnership\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"ethAmount\",\"type\":\"uint256\"}],\"name\":\"calculateFrames\",\"outputs\":[{\"name\":\"frames\",\"type\":\"uint256\"},{\"name\":\"ethToTransfer\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"pctSold\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"tokenOwner\",\"type\":\"address\"},{\"name\":\"frames\",\"type\":\"uint256\"}],\"name\":\"offlineFramesPurchase\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"\",\"type\":\"address\"}],\"name\":\"accountEthAmount\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"name\":\"_frameRushToken\",\"type\":\"address\"},{\"name\":\"_royaltyToken\",\"type\":\"address\"},{\"name\":\"_ethUsdPriceFeed\",\"type\":\"address\"},{\"name\":\"_whiteList\",\"type\":\"address\"},{\"name\":\"_wallet\",\"type\":\"address\"},{\"name\":\"_startDate\",\"type\":\"uint256\"},{\"name\":\"_endDate\",\"type\":\"uint256\"},{\"name\":\"_maxFrames\",\"type\":\"uint256\"},{\"name\":\"_frameUsd\",\"type\":\"uint256\"},{\"name\":\"_bonusOffList\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"fallback\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"oldWallet\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"newWallet\",\"type\":\"address\"}],\"name\":\"WalletUpdated\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"oldStartDate\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"newStartDate\",\"type\":\"uint256\"}],\"name\":\"StartDateUpdated\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"oldEndDate\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"newEndDate\",\"type\":\"uint256\"}],\"name\":\"EndDateUpdated\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"oldMaxFrames\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"newMaxFrames\",\"type\":\"uint256\"}],\"name\":\"MaxFramesUpdated\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"oldFrameUsd\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"newFrameUsd\",\"type\":\"uint256\"}],\"name\":\"FrameUsdUpdated\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"oldBonusOffList\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"newBonusOffList\",\"type\":\"uint256\"}],\"name\":\"BonusOffListUpdated\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"addr\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"frames\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"ethToTransfer\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"framesSold\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"contributedEth\",\"type\":\"uint256\"}],\"name\":\"Purchased\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"oldRoyaltyCrowdsaleAddress\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"newRoyaltyCrowdsaleAddres\",\"type\":\"address\"}],\"name\":\"RoyaltyCrowdsaleUpdated\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"}],\"name\":\"OwnershipTransferred\",\"type\":\"event\"}]"

// Crowdsale is an auto generated Go binding around an Ethereum contract.
type Crowdsale struct {
	CrowdsaleCaller     // Read-only binding to the contract
	CrowdsaleTransactor // Write-only binding to the contract
	CrowdsaleFilterer   // Log filterer for contract events
}

// CrowdsaleCaller is an auto generated read-only Go binding around an Ethereum contract.
type CrowdsaleCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// CrowdsaleTransactor is an auto generated write-only Go binding around an Ethereum contract.
type CrowdsaleTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// CrowdsaleFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type CrowdsaleFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// CrowdsaleSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type CrowdsaleSession struct {
	Contract     *Crowdsale        // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// CrowdsaleCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type CrowdsaleCallerSession struct {
	Contract *CrowdsaleCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts    // Call options to use throughout this session
}

// CrowdsaleTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type CrowdsaleTransactorSession struct {
	Contract     *CrowdsaleTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts    // Transaction auth options to use throughout this session
}

// CrowdsaleRaw is an auto generated low-level Go binding around an Ethereum contract.
type CrowdsaleRaw struct {
	Contract *Crowdsale // Generic contract binding to access the raw methods on
}

// CrowdsaleCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type CrowdsaleCallerRaw struct {
	Contract *CrowdsaleCaller // Generic read-only contract binding to access the raw methods on
}

// CrowdsaleTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type CrowdsaleTransactorRaw struct {
	Contract *CrowdsaleTransactor // Generic write-only contract binding to access the raw methods on
}

// NewCrowdsale creates a new instance of Crowdsale, bound to a specific deployed contract.
func NewCrowdsale(address common.Address, backend bind.ContractBackend) (*Crowdsale, error) {
	contract, err := bindCrowdsale(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &Crowdsale{CrowdsaleCaller: CrowdsaleCaller{contract: contract}, CrowdsaleTransactor: CrowdsaleTransactor{contract: contract}, CrowdsaleFilterer: CrowdsaleFilterer{contract: contract}}, nil
}

// NewCrowdsaleCaller creates a new read-only instance of Crowdsale, bound to a specific deployed contract.
func NewCrowdsaleCaller(address common.Address, caller bind.ContractCaller) (*CrowdsaleCaller, error) {
	contract, err := bindCrowdsale(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &CrowdsaleCaller{contract: contract}, nil
}

// NewCrowdsaleTransactor creates a new write-only instance of Crowdsale, bound to a specific deployed contract.
func NewCrowdsaleTransactor(address common.Address, transactor bind.ContractTransactor) (*CrowdsaleTransactor, error) {
	contract, err := bindCrowdsale(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &CrowdsaleTransactor{contract: contract}, nil
}

// NewCrowdsaleFilterer creates a new log filterer instance of Crowdsale, bound to a specific deployed contract.
func NewCrowdsaleFilterer(address common.Address, filterer bind.ContractFilterer) (*CrowdsaleFilterer, error) {
	contract, err := bindCrowdsale(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &CrowdsaleFilterer{contract: contract}, nil
}

// bindCrowdsale binds a generic wrapper to an already deployed contract.
func bindCrowdsale(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(CrowdsaleABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Crowdsale *CrowdsaleRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _Crowdsale.Contract.CrowdsaleCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Crowdsale *CrowdsaleRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Crowdsale.Contract.CrowdsaleTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Crowdsale *CrowdsaleRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Crowdsale.Contract.CrowdsaleTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Crowdsale *CrowdsaleCallerRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _Crowdsale.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Crowdsale *CrowdsaleTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Crowdsale.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Crowdsale *CrowdsaleTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Crowdsale.Contract.contract.Transact(opts, method, params...)
}

// AccountEthAmount is a free data retrieval call binding the contract method 0xff8872c2.
//
// Solidity: function accountEthAmount(address ) constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) AccountEthAmount(opts *bind.CallOpts, arg0 common.Address) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "accountEthAmount", arg0)
	return *ret0, err
}

// AccountEthAmount is a free data retrieval call binding the contract method 0xff8872c2.
//
// Solidity: function accountEthAmount(address ) constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) AccountEthAmount(arg0 common.Address) (*big.Int, error) {
	return _Crowdsale.Contract.AccountEthAmount(&_Crowdsale.CallOpts, arg0)
}

// AccountEthAmount is a free data retrieval call binding the contract method 0xff8872c2.
//
// Solidity: function accountEthAmount(address ) constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) AccountEthAmount(arg0 common.Address) (*big.Int, error) {
	return _Crowdsale.Contract.AccountEthAmount(&_Crowdsale.CallOpts, arg0)
}

// BonusOffList is a free data retrieval call binding the contract method 0xe5eaf212.
//
// Solidity: function bonusOffList() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) BonusOffList(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "bonusOffList")
	return *ret0, err
}

// BonusOffList is a free data retrieval call binding the contract method 0xe5eaf212.
//
// Solidity: function bonusOffList() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) BonusOffList() (*big.Int, error) {
	return _Crowdsale.Contract.BonusOffList(&_Crowdsale.CallOpts)
}

// BonusOffList is a free data retrieval call binding the contract method 0xe5eaf212.
//
// Solidity: function bonusOffList() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) BonusOffList() (*big.Int, error) {
	return _Crowdsale.Contract.BonusOffList(&_Crowdsale.CallOpts)
}

// CalculateFrames is a free data retrieval call binding the contract method 0xfc33d88d.
//
// Solidity: function calculateFrames(uint256 ethAmount) constant returns(uint256 frames, uint256 ethToTransfer)
func (_Crowdsale *CrowdsaleCaller) CalculateFrames(opts *bind.CallOpts, ethAmount *big.Int) (struct {
	Frames        *big.Int
	EthToTransfer *big.Int
}, error) {
	ret := new(struct {
		Frames        *big.Int
		EthToTransfer *big.Int
	})
	out := ret
	err := _Crowdsale.contract.Call(opts, out, "calculateFrames", ethAmount)
	return *ret, err
}

// CalculateFrames is a free data retrieval call binding the contract method 0xfc33d88d.
//
// Solidity: function calculateFrames(uint256 ethAmount) constant returns(uint256 frames, uint256 ethToTransfer)
func (_Crowdsale *CrowdsaleSession) CalculateFrames(ethAmount *big.Int) (struct {
	Frames        *big.Int
	EthToTransfer *big.Int
}, error) {
	return _Crowdsale.Contract.CalculateFrames(&_Crowdsale.CallOpts, ethAmount)
}

// CalculateFrames is a free data retrieval call binding the contract method 0xfc33d88d.
//
// Solidity: function calculateFrames(uint256 ethAmount) constant returns(uint256 frames, uint256 ethToTransfer)
func (_Crowdsale *CrowdsaleCallerSession) CalculateFrames(ethAmount *big.Int) (struct {
	Frames        *big.Int
	EthToTransfer *big.Int
}, error) {
	return _Crowdsale.Contract.CalculateFrames(&_Crowdsale.CallOpts, ethAmount)
}

// ContributedEth is a free data retrieval call binding the contract method 0xb4d3ef5f.
//
// Solidity: function contributedEth() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) ContributedEth(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "contributedEth")
	return *ret0, err
}

// ContributedEth is a free data retrieval call binding the contract method 0xb4d3ef5f.
//
// Solidity: function contributedEth() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) ContributedEth() (*big.Int, error) {
	return _Crowdsale.Contract.ContributedEth(&_Crowdsale.CallOpts)
}

// ContributedEth is a free data retrieval call binding the contract method 0xb4d3ef5f.
//
// Solidity: function contributedEth() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) ContributedEth() (*big.Int, error) {
	return _Crowdsale.Contract.ContributedEth(&_Crowdsale.CallOpts)
}

// EndDate is a free data retrieval call binding the contract method 0xc24a0f8b.
//
// Solidity: function endDate() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) EndDate(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "endDate")
	return *ret0, err
}

// EndDate is a free data retrieval call binding the contract method 0xc24a0f8b.
//
// Solidity: function endDate() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) EndDate() (*big.Int, error) {
	return _Crowdsale.Contract.EndDate(&_Crowdsale.CallOpts)
}

// EndDate is a free data retrieval call binding the contract method 0xc24a0f8b.
//
// Solidity: function endDate() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) EndDate() (*big.Int, error) {
	return _Crowdsale.Contract.EndDate(&_Crowdsale.CallOpts)
}

// EthUsd is a free data retrieval call binding the contract method 0x5a960216.
//
// Solidity: function ethUsd() constant returns(uint256 _rate, bool _live)
func (_Crowdsale *CrowdsaleCaller) EthUsd(opts *bind.CallOpts) (struct {
	Rate *big.Int
	Live bool
}, error) {
	ret := new(struct {
		Rate *big.Int
		Live bool
	})
	out := ret
	err := _Crowdsale.contract.Call(opts, out, "ethUsd")
	return *ret, err
}

// EthUsd is a free data retrieval call binding the contract method 0x5a960216.
//
// Solidity: function ethUsd() constant returns(uint256 _rate, bool _live)
func (_Crowdsale *CrowdsaleSession) EthUsd() (struct {
	Rate *big.Int
	Live bool
}, error) {
	return _Crowdsale.Contract.EthUsd(&_Crowdsale.CallOpts)
}

// EthUsd is a free data retrieval call binding the contract method 0x5a960216.
//
// Solidity: function ethUsd() constant returns(uint256 _rate, bool _live)
func (_Crowdsale *CrowdsaleCallerSession) EthUsd() (struct {
	Rate *big.Int
	Live bool
}, error) {
	return _Crowdsale.Contract.EthUsd(&_Crowdsale.CallOpts)
}

// EthUsdPriceFeed is a free data retrieval call binding the contract method 0x42f6fb29.
//
// Solidity: function ethUsdPriceFeed() constant returns(address)
func (_Crowdsale *CrowdsaleCaller) EthUsdPriceFeed(opts *bind.CallOpts) (common.Address, error) {
	var (
		ret0 = new(common.Address)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "ethUsdPriceFeed")
	return *ret0, err
}

// EthUsdPriceFeed is a free data retrieval call binding the contract method 0x42f6fb29.
//
// Solidity: function ethUsdPriceFeed() constant returns(address)
func (_Crowdsale *CrowdsaleSession) EthUsdPriceFeed() (common.Address, error) {
	return _Crowdsale.Contract.EthUsdPriceFeed(&_Crowdsale.CallOpts)
}

// EthUsdPriceFeed is a free data retrieval call binding the contract method 0x42f6fb29.
//
// Solidity: function ethUsdPriceFeed() constant returns(address)
func (_Crowdsale *CrowdsaleCallerSession) EthUsdPriceFeed() (common.Address, error) {
	return _Crowdsale.Contract.EthUsdPriceFeed(&_Crowdsale.CallOpts)
}

// Finalised is a free data retrieval call binding the contract method 0x214bb60f.
//
// Solidity: function finalised() constant returns(bool)
func (_Crowdsale *CrowdsaleCaller) Finalised(opts *bind.CallOpts) (bool, error) {
	var (
		ret0 = new(bool)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "finalised")
	return *ret0, err
}

// Finalised is a free data retrieval call binding the contract method 0x214bb60f.
//
// Solidity: function finalised() constant returns(bool)
func (_Crowdsale *CrowdsaleSession) Finalised() (bool, error) {
	return _Crowdsale.Contract.Finalised(&_Crowdsale.CallOpts)
}

// Finalised is a free data retrieval call binding the contract method 0x214bb60f.
//
// Solidity: function finalised() constant returns(bool)
func (_Crowdsale *CrowdsaleCallerSession) Finalised() (bool, error) {
	return _Crowdsale.Contract.Finalised(&_Crowdsale.CallOpts)
}

// FrameEth is a free data retrieval call binding the contract method 0xc4f3913b.
//
// Solidity: function frameEth() constant returns(uint256 _rate, bool _live)
func (_Crowdsale *CrowdsaleCaller) FrameEth(opts *bind.CallOpts) (struct {
	Rate *big.Int
	Live bool
}, error) {
	ret := new(struct {
		Rate *big.Int
		Live bool
	})
	out := ret
	err := _Crowdsale.contract.Call(opts, out, "frameEth")
	return *ret, err
}

// FrameEth is a free data retrieval call binding the contract method 0xc4f3913b.
//
// Solidity: function frameEth() constant returns(uint256 _rate, bool _live)
func (_Crowdsale *CrowdsaleSession) FrameEth() (struct {
	Rate *big.Int
	Live bool
}, error) {
	return _Crowdsale.Contract.FrameEth(&_Crowdsale.CallOpts)
}

// FrameEth is a free data retrieval call binding the contract method 0xc4f3913b.
//
// Solidity: function frameEth() constant returns(uint256 _rate, bool _live)
func (_Crowdsale *CrowdsaleCallerSession) FrameEth() (struct {
	Rate *big.Int
	Live bool
}, error) {
	return _Crowdsale.Contract.FrameEth(&_Crowdsale.CallOpts)
}

// FrameRushToken is a free data retrieval call binding the contract method 0x4077119b.
//
// Solidity: function frameRushToken() constant returns(address)
func (_Crowdsale *CrowdsaleCaller) FrameRushToken(opts *bind.CallOpts) (common.Address, error) {
	var (
		ret0 = new(common.Address)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "frameRushToken")
	return *ret0, err
}

// FrameRushToken is a free data retrieval call binding the contract method 0x4077119b.
//
// Solidity: function frameRushToken() constant returns(address)
func (_Crowdsale *CrowdsaleSession) FrameRushToken() (common.Address, error) {
	return _Crowdsale.Contract.FrameRushToken(&_Crowdsale.CallOpts)
}

// FrameRushToken is a free data retrieval call binding the contract method 0x4077119b.
//
// Solidity: function frameRushToken() constant returns(address)
func (_Crowdsale *CrowdsaleCallerSession) FrameRushToken() (common.Address, error) {
	return _Crowdsale.Contract.FrameRushToken(&_Crowdsale.CallOpts)
}

// FrameUsd is a free data retrieval call binding the contract method 0xdbdef723.
//
// Solidity: function frameUsd() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) FrameUsd(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "frameUsd")
	return *ret0, err
}

// FrameUsd is a free data retrieval call binding the contract method 0xdbdef723.
//
// Solidity: function frameUsd() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) FrameUsd() (*big.Int, error) {
	return _Crowdsale.Contract.FrameUsd(&_Crowdsale.CallOpts)
}

// FrameUsd is a free data retrieval call binding the contract method 0xdbdef723.
//
// Solidity: function frameUsd() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) FrameUsd() (*big.Int, error) {
	return _Crowdsale.Contract.FrameUsd(&_Crowdsale.CallOpts)
}

// FrameUsdWithBonus is a free data retrieval call binding the contract method 0xdda3efb8.
//
// Solidity: function frameUsdWithBonus() constant returns(uint256 _rate)
func (_Crowdsale *CrowdsaleCaller) FrameUsdWithBonus(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "frameUsdWithBonus")
	return *ret0, err
}

// FrameUsdWithBonus is a free data retrieval call binding the contract method 0xdda3efb8.
//
// Solidity: function frameUsdWithBonus() constant returns(uint256 _rate)
func (_Crowdsale *CrowdsaleSession) FrameUsdWithBonus() (*big.Int, error) {
	return _Crowdsale.Contract.FrameUsdWithBonus(&_Crowdsale.CallOpts)
}

// FrameUsdWithBonus is a free data retrieval call binding the contract method 0xdda3efb8.
//
// Solidity: function frameUsdWithBonus() constant returns(uint256 _rate)
func (_Crowdsale *CrowdsaleCallerSession) FrameUsdWithBonus() (*big.Int, error) {
	return _Crowdsale.Contract.FrameUsdWithBonus(&_Crowdsale.CallOpts)
}

// FramesSold is a free data retrieval call binding the contract method 0xe448f37f.
//
// Solidity: function framesSold() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) FramesSold(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "framesSold")
	return *ret0, err
}

// FramesSold is a free data retrieval call binding the contract method 0xe448f37f.
//
// Solidity: function framesSold() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) FramesSold() (*big.Int, error) {
	return _Crowdsale.Contract.FramesSold(&_Crowdsale.CallOpts)
}

// FramesSold is a free data retrieval call binding the contract method 0xe448f37f.
//
// Solidity: function framesSold() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) FramesSold() (*big.Int, error) {
	return _Crowdsale.Contract.FramesSold(&_Crowdsale.CallOpts)
}

// HardCapEth is a free data retrieval call binding the contract method 0x1c382c6b.
//
// Solidity: function hardCapEth() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) HardCapEth(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "hardCapEth")
	return *ret0, err
}

// HardCapEth is a free data retrieval call binding the contract method 0x1c382c6b.
//
// Solidity: function hardCapEth() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) HardCapEth() (*big.Int, error) {
	return _Crowdsale.Contract.HardCapEth(&_Crowdsale.CallOpts)
}

// HardCapEth is a free data retrieval call binding the contract method 0x1c382c6b.
//
// Solidity: function hardCapEth() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) HardCapEth() (*big.Int, error) {
	return _Crowdsale.Contract.HardCapEth(&_Crowdsale.CallOpts)
}

// HardCapUsd is a free data retrieval call binding the contract method 0x81e7cb7c.
//
// Solidity: function hardCapUsd() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) HardCapUsd(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "hardCapUsd")
	return *ret0, err
}

// HardCapUsd is a free data retrieval call binding the contract method 0x81e7cb7c.
//
// Solidity: function hardCapUsd() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) HardCapUsd() (*big.Int, error) {
	return _Crowdsale.Contract.HardCapUsd(&_Crowdsale.CallOpts)
}

// HardCapUsd is a free data retrieval call binding the contract method 0x81e7cb7c.
//
// Solidity: function hardCapUsd() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) HardCapUsd() (*big.Int, error) {
	return _Crowdsale.Contract.HardCapUsd(&_Crowdsale.CallOpts)
}

// LockedAccountThresholdEth is a free data retrieval call binding the contract method 0x8a654a64.
//
// Solidity: function lockedAccountThresholdEth() constant returns(uint256 _amount)
func (_Crowdsale *CrowdsaleCaller) LockedAccountThresholdEth(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "lockedAccountThresholdEth")
	return *ret0, err
}

// LockedAccountThresholdEth is a free data retrieval call binding the contract method 0x8a654a64.
//
// Solidity: function lockedAccountThresholdEth() constant returns(uint256 _amount)
func (_Crowdsale *CrowdsaleSession) LockedAccountThresholdEth() (*big.Int, error) {
	return _Crowdsale.Contract.LockedAccountThresholdEth(&_Crowdsale.CallOpts)
}

// LockedAccountThresholdEth is a free data retrieval call binding the contract method 0x8a654a64.
//
// Solidity: function lockedAccountThresholdEth() constant returns(uint256 _amount)
func (_Crowdsale *CrowdsaleCallerSession) LockedAccountThresholdEth() (*big.Int, error) {
	return _Crowdsale.Contract.LockedAccountThresholdEth(&_Crowdsale.CallOpts)
}

// LockedAccountThresholdUsd is a free data retrieval call binding the contract method 0x9eddc441.
//
// Solidity: function lockedAccountThresholdUsd() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) LockedAccountThresholdUsd(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "lockedAccountThresholdUsd")
	return *ret0, err
}

// LockedAccountThresholdUsd is a free data retrieval call binding the contract method 0x9eddc441.
//
// Solidity: function lockedAccountThresholdUsd() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) LockedAccountThresholdUsd() (*big.Int, error) {
	return _Crowdsale.Contract.LockedAccountThresholdUsd(&_Crowdsale.CallOpts)
}

// LockedAccountThresholdUsd is a free data retrieval call binding the contract method 0x9eddc441.
//
// Solidity: function lockedAccountThresholdUsd() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) LockedAccountThresholdUsd() (*big.Int, error) {
	return _Crowdsale.Contract.LockedAccountThresholdUsd(&_Crowdsale.CallOpts)
}

// MaxFrames is a free data retrieval call binding the contract method 0xd72ad102.
//
// Solidity: function maxFrames() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) MaxFrames(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "maxFrames")
	return *ret0, err
}

// MaxFrames is a free data retrieval call binding the contract method 0xd72ad102.
//
// Solidity: function maxFrames() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) MaxFrames() (*big.Int, error) {
	return _Crowdsale.Contract.MaxFrames(&_Crowdsale.CallOpts)
}

// MaxFrames is a free data retrieval call binding the contract method 0xd72ad102.
//
// Solidity: function maxFrames() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) MaxFrames() (*big.Int, error) {
	return _Crowdsale.Contract.MaxFrames(&_Crowdsale.CallOpts)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() constant returns(string _name)
func (_Crowdsale *CrowdsaleCaller) Name(opts *bind.CallOpts) (string, error) {
	var (
		ret0 = new(string)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "name")
	return *ret0, err
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() constant returns(string _name)
func (_Crowdsale *CrowdsaleSession) Name() (string, error) {
	return _Crowdsale.Contract.Name(&_Crowdsale.CallOpts)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() constant returns(string _name)
func (_Crowdsale *CrowdsaleCallerSession) Name() (string, error) {
	return _Crowdsale.Contract.Name(&_Crowdsale.CallOpts)
}

// NewOwner is a free data retrieval call binding the contract method 0xd4ee1d90.
//
// Solidity: function newOwner() constant returns(address)
func (_Crowdsale *CrowdsaleCaller) NewOwner(opts *bind.CallOpts) (common.Address, error) {
	var (
		ret0 = new(common.Address)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "newOwner")
	return *ret0, err
}

// NewOwner is a free data retrieval call binding the contract method 0xd4ee1d90.
//
// Solidity: function newOwner() constant returns(address)
func (_Crowdsale *CrowdsaleSession) NewOwner() (common.Address, error) {
	return _Crowdsale.Contract.NewOwner(&_Crowdsale.CallOpts)
}

// NewOwner is a free data retrieval call binding the contract method 0xd4ee1d90.
//
// Solidity: function newOwner() constant returns(address)
func (_Crowdsale *CrowdsaleCallerSession) NewOwner() (common.Address, error) {
	return _Crowdsale.Contract.NewOwner(&_Crowdsale.CallOpts)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() constant returns(address)
func (_Crowdsale *CrowdsaleCaller) Owner(opts *bind.CallOpts) (common.Address, error) {
	var (
		ret0 = new(common.Address)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "owner")
	return *ret0, err
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() constant returns(address)
func (_Crowdsale *CrowdsaleSession) Owner() (common.Address, error) {
	return _Crowdsale.Contract.Owner(&_Crowdsale.CallOpts)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() constant returns(address)
func (_Crowdsale *CrowdsaleCallerSession) Owner() (common.Address, error) {
	return _Crowdsale.Contract.Owner(&_Crowdsale.CallOpts)
}

// PctRemaining is a free data retrieval call binding the contract method 0x15cde9b7.
//
// Solidity: function pctRemaining() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) PctRemaining(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "pctRemaining")
	return *ret0, err
}

// PctRemaining is a free data retrieval call binding the contract method 0x15cde9b7.
//
// Solidity: function pctRemaining() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) PctRemaining() (*big.Int, error) {
	return _Crowdsale.Contract.PctRemaining(&_Crowdsale.CallOpts)
}

// PctRemaining is a free data retrieval call binding the contract method 0x15cde9b7.
//
// Solidity: function pctRemaining() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) PctRemaining() (*big.Int, error) {
	return _Crowdsale.Contract.PctRemaining(&_Crowdsale.CallOpts)
}

// PctSold is a free data retrieval call binding the contract method 0xfcc5dc3d.
//
// Solidity: function pctSold() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) PctSold(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "pctSold")
	return *ret0, err
}

// PctSold is a free data retrieval call binding the contract method 0xfcc5dc3d.
//
// Solidity: function pctSold() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) PctSold() (*big.Int, error) {
	return _Crowdsale.Contract.PctSold(&_Crowdsale.CallOpts)
}

// PctSold is a free data retrieval call binding the contract method 0xfcc5dc3d.
//
// Solidity: function pctSold() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) PctSold() (*big.Int, error) {
	return _Crowdsale.Contract.PctSold(&_Crowdsale.CallOpts)
}

// RoyaltyCrowdsaleAddress is a free data retrieval call binding the contract method 0xe4c53c91.
//
// Solidity: function royaltyCrowdsaleAddress() constant returns(address)
func (_Crowdsale *CrowdsaleCaller) RoyaltyCrowdsaleAddress(opts *bind.CallOpts) (common.Address, error) {
	var (
		ret0 = new(common.Address)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "royaltyCrowdsaleAddress")
	return *ret0, err
}

// RoyaltyCrowdsaleAddress is a free data retrieval call binding the contract method 0xe4c53c91.
//
// Solidity: function royaltyCrowdsaleAddress() constant returns(address)
func (_Crowdsale *CrowdsaleSession) RoyaltyCrowdsaleAddress() (common.Address, error) {
	return _Crowdsale.Contract.RoyaltyCrowdsaleAddress(&_Crowdsale.CallOpts)
}

// RoyaltyCrowdsaleAddress is a free data retrieval call binding the contract method 0xe4c53c91.
//
// Solidity: function royaltyCrowdsaleAddress() constant returns(address)
func (_Crowdsale *CrowdsaleCallerSession) RoyaltyCrowdsaleAddress() (common.Address, error) {
	return _Crowdsale.Contract.RoyaltyCrowdsaleAddress(&_Crowdsale.CallOpts)
}

// RoyaltyToken is a free data retrieval call binding the contract method 0xb96354cf.
//
// Solidity: function royaltyToken() constant returns(address)
func (_Crowdsale *CrowdsaleCaller) RoyaltyToken(opts *bind.CallOpts) (common.Address, error) {
	var (
		ret0 = new(common.Address)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "royaltyToken")
	return *ret0, err
}

// RoyaltyToken is a free data retrieval call binding the contract method 0xb96354cf.
//
// Solidity: function royaltyToken() constant returns(address)
func (_Crowdsale *CrowdsaleSession) RoyaltyToken() (common.Address, error) {
	return _Crowdsale.Contract.RoyaltyToken(&_Crowdsale.CallOpts)
}

// RoyaltyToken is a free data retrieval call binding the contract method 0xb96354cf.
//
// Solidity: function royaltyToken() constant returns(address)
func (_Crowdsale *CrowdsaleCallerSession) RoyaltyToken() (common.Address, error) {
	return _Crowdsale.Contract.RoyaltyToken(&_Crowdsale.CallOpts)
}

// SoftCapEth is a free data retrieval call binding the contract method 0xd3ee42b5.
//
// Solidity: function softCapEth() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) SoftCapEth(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "softCapEth")
	return *ret0, err
}

// SoftCapEth is a free data retrieval call binding the contract method 0xd3ee42b5.
//
// Solidity: function softCapEth() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) SoftCapEth() (*big.Int, error) {
	return _Crowdsale.Contract.SoftCapEth(&_Crowdsale.CallOpts)
}

// SoftCapEth is a free data retrieval call binding the contract method 0xd3ee42b5.
//
// Solidity: function softCapEth() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) SoftCapEth() (*big.Int, error) {
	return _Crowdsale.Contract.SoftCapEth(&_Crowdsale.CallOpts)
}

// SoftCapUsd is a free data retrieval call binding the contract method 0x63bce4e7.
//
// Solidity: function softCapUsd() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) SoftCapUsd(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "softCapUsd")
	return *ret0, err
}

// SoftCapUsd is a free data retrieval call binding the contract method 0x63bce4e7.
//
// Solidity: function softCapUsd() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) SoftCapUsd() (*big.Int, error) {
	return _Crowdsale.Contract.SoftCapUsd(&_Crowdsale.CallOpts)
}

// SoftCapUsd is a free data retrieval call binding the contract method 0x63bce4e7.
//
// Solidity: function softCapUsd() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) SoftCapUsd() (*big.Int, error) {
	return _Crowdsale.Contract.SoftCapUsd(&_Crowdsale.CallOpts)
}

// StartDate is a free data retrieval call binding the contract method 0x0b97bc86.
//
// Solidity: function startDate() constant returns(uint256)
func (_Crowdsale *CrowdsaleCaller) StartDate(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "startDate")
	return *ret0, err
}

// StartDate is a free data retrieval call binding the contract method 0x0b97bc86.
//
// Solidity: function startDate() constant returns(uint256)
func (_Crowdsale *CrowdsaleSession) StartDate() (*big.Int, error) {
	return _Crowdsale.Contract.StartDate(&_Crowdsale.CallOpts)
}

// StartDate is a free data retrieval call binding the contract method 0x0b97bc86.
//
// Solidity: function startDate() constant returns(uint256)
func (_Crowdsale *CrowdsaleCallerSession) StartDate() (*big.Int, error) {
	return _Crowdsale.Contract.StartDate(&_Crowdsale.CallOpts)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() constant returns(string _symbol)
func (_Crowdsale *CrowdsaleCaller) Symbol(opts *bind.CallOpts) (string, error) {
	var (
		ret0 = new(string)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "symbol")
	return *ret0, err
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() constant returns(string _symbol)
func (_Crowdsale *CrowdsaleSession) Symbol() (string, error) {
	return _Crowdsale.Contract.Symbol(&_Crowdsale.CallOpts)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() constant returns(string _symbol)
func (_Crowdsale *CrowdsaleCallerSession) Symbol() (string, error) {
	return _Crowdsale.Contract.Symbol(&_Crowdsale.CallOpts)
}

// Wallet is a free data retrieval call binding the contract method 0x521eb273.
//
// Solidity: function wallet() constant returns(address)
func (_Crowdsale *CrowdsaleCaller) Wallet(opts *bind.CallOpts) (common.Address, error) {
	var (
		ret0 = new(common.Address)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "wallet")
	return *ret0, err
}

// Wallet is a free data retrieval call binding the contract method 0x521eb273.
//
// Solidity: function wallet() constant returns(address)
func (_Crowdsale *CrowdsaleSession) Wallet() (common.Address, error) {
	return _Crowdsale.Contract.Wallet(&_Crowdsale.CallOpts)
}

// Wallet is a free data retrieval call binding the contract method 0x521eb273.
//
// Solidity: function wallet() constant returns(address)
func (_Crowdsale *CrowdsaleCallerSession) Wallet() (common.Address, error) {
	return _Crowdsale.Contract.Wallet(&_Crowdsale.CallOpts)
}

// WhiteList is a free data retrieval call binding the contract method 0x3544a864.
//
// Solidity: function whiteList() constant returns(address)
func (_Crowdsale *CrowdsaleCaller) WhiteList(opts *bind.CallOpts) (common.Address, error) {
	var (
		ret0 = new(common.Address)
	)
	out := ret0
	err := _Crowdsale.contract.Call(opts, out, "whiteList")
	return *ret0, err
}

// WhiteList is a free data retrieval call binding the contract method 0x3544a864.
//
// Solidity: function whiteList() constant returns(address)
func (_Crowdsale *CrowdsaleSession) WhiteList() (common.Address, error) {
	return _Crowdsale.Contract.WhiteList(&_Crowdsale.CallOpts)
}

// WhiteList is a free data retrieval call binding the contract method 0x3544a864.
//
// Solidity: function whiteList() constant returns(address)
func (_Crowdsale *CrowdsaleCallerSession) WhiteList() (common.Address, error) {
	return _Crowdsale.Contract.WhiteList(&_Crowdsale.CallOpts)
}

// AcceptOwnership is a paid mutator transaction binding the contract method 0x79ba5097.
//
// Solidity: function acceptOwnership() returns()
func (_Crowdsale *CrowdsaleTransactor) AcceptOwnership(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Crowdsale.contract.Transact(opts, "acceptOwnership")
}

// AcceptOwnership is a paid mutator transaction binding the contract method 0x79ba5097.
//
// Solidity: function acceptOwnership() returns()
func (_Crowdsale *CrowdsaleSession) AcceptOwnership() (*types.Transaction, error) {
	return _Crowdsale.Contract.AcceptOwnership(&_Crowdsale.TransactOpts)
}

// AcceptOwnership is a paid mutator transaction binding the contract method 0x79ba5097.
//
// Solidity: function acceptOwnership() returns()
func (_Crowdsale *CrowdsaleTransactorSession) AcceptOwnership() (*types.Transaction, error) {
	return _Crowdsale.Contract.AcceptOwnership(&_Crowdsale.TransactOpts)
}

// ClaimRoyaltyFrames is a paid mutator transaction binding the contract method 0xd0f344c0.
//
// Solidity: function claimRoyaltyFrames(address tokenOwner, uint256 frames, uint256 ethToTransfer) returns()
func (_Crowdsale *CrowdsaleTransactor) ClaimRoyaltyFrames(opts *bind.TransactOpts, tokenOwner common.Address, frames *big.Int, ethToTransfer *big.Int) (*types.Transaction, error) {
	return _Crowdsale.contract.Transact(opts, "claimRoyaltyFrames", tokenOwner, frames, ethToTransfer)
}

// ClaimRoyaltyFrames is a paid mutator transaction binding the contract method 0xd0f344c0.
//
// Solidity: function claimRoyaltyFrames(address tokenOwner, uint256 frames, uint256 ethToTransfer) returns()
func (_Crowdsale *CrowdsaleSession) ClaimRoyaltyFrames(tokenOwner common.Address, frames *big.Int, ethToTransfer *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.ClaimRoyaltyFrames(&_Crowdsale.TransactOpts, tokenOwner, frames, ethToTransfer)
}

// ClaimRoyaltyFrames is a paid mutator transaction binding the contract method 0xd0f344c0.
//
// Solidity: function claimRoyaltyFrames(address tokenOwner, uint256 frames, uint256 ethToTransfer) returns()
func (_Crowdsale *CrowdsaleTransactorSession) ClaimRoyaltyFrames(tokenOwner common.Address, frames *big.Int, ethToTransfer *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.ClaimRoyaltyFrames(&_Crowdsale.TransactOpts, tokenOwner, frames, ethToTransfer)
}

// Finalise is a paid mutator transaction binding the contract method 0xa4399263.
//
// Solidity: function finalise() returns()
func (_Crowdsale *CrowdsaleTransactor) Finalise(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Crowdsale.contract.Transact(opts, "finalise")
}

// Finalise is a paid mutator transaction binding the contract method 0xa4399263.
//
// Solidity: function finalise() returns()
func (_Crowdsale *CrowdsaleSession) Finalise() (*types.Transaction, error) {
	return _Crowdsale.Contract.Finalise(&_Crowdsale.TransactOpts)
}

// Finalise is a paid mutator transaction binding the contract method 0xa4399263.
//
// Solidity: function finalise() returns()
func (_Crowdsale *CrowdsaleTransactorSession) Finalise() (*types.Transaction, error) {
	return _Crowdsale.Contract.Finalise(&_Crowdsale.TransactOpts)
}

// OfflineFramesPurchase is a paid mutator transaction binding the contract method 0xfd5eb66b.
//
// Solidity: function offlineFramesPurchase(address tokenOwner, uint256 frames) returns()
func (_Crowdsale *CrowdsaleTransactor) OfflineFramesPurchase(opts *bind.TransactOpts, tokenOwner common.Address, frames *big.Int) (*types.Transaction, error) {
	return _Crowdsale.contract.Transact(opts, "offlineFramesPurchase", tokenOwner, frames)
}

// OfflineFramesPurchase is a paid mutator transaction binding the contract method 0xfd5eb66b.
//
// Solidity: function offlineFramesPurchase(address tokenOwner, uint256 frames) returns()
func (_Crowdsale *CrowdsaleSession) OfflineFramesPurchase(tokenOwner common.Address, frames *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.OfflineFramesPurchase(&_Crowdsale.TransactOpts, tokenOwner, frames)
}

// OfflineFramesPurchase is a paid mutator transaction binding the contract method 0xfd5eb66b.
//
// Solidity: function offlineFramesPurchase(address tokenOwner, uint256 frames) returns()
func (_Crowdsale *CrowdsaleTransactorSession) OfflineFramesPurchase(tokenOwner common.Address, frames *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.OfflineFramesPurchase(&_Crowdsale.TransactOpts, tokenOwner, frames)
}

// SetBonusOffList is a paid mutator transaction binding the contract method 0x86bd5ec6.
//
// Solidity: function setBonusOffList(uint256 _bonusOffList) returns()
func (_Crowdsale *CrowdsaleTransactor) SetBonusOffList(opts *bind.TransactOpts, _bonusOffList *big.Int) (*types.Transaction, error) {
	return _Crowdsale.contract.Transact(opts, "setBonusOffList", _bonusOffList)
}

// SetBonusOffList is a paid mutator transaction binding the contract method 0x86bd5ec6.
//
// Solidity: function setBonusOffList(uint256 _bonusOffList) returns()
func (_Crowdsale *CrowdsaleSession) SetBonusOffList(_bonusOffList *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetBonusOffList(&_Crowdsale.TransactOpts, _bonusOffList)
}

// SetBonusOffList is a paid mutator transaction binding the contract method 0x86bd5ec6.
//
// Solidity: function setBonusOffList(uint256 _bonusOffList) returns()
func (_Crowdsale *CrowdsaleTransactorSession) SetBonusOffList(_bonusOffList *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetBonusOffList(&_Crowdsale.TransactOpts, _bonusOffList)
}

// SetEndDate is a paid mutator transaction binding the contract method 0x3784f000.
//
// Solidity: function setEndDate(uint256 _endDate) returns()
func (_Crowdsale *CrowdsaleTransactor) SetEndDate(opts *bind.TransactOpts, _endDate *big.Int) (*types.Transaction, error) {
	return _Crowdsale.contract.Transact(opts, "setEndDate", _endDate)
}

// SetEndDate is a paid mutator transaction binding the contract method 0x3784f000.
//
// Solidity: function setEndDate(uint256 _endDate) returns()
func (_Crowdsale *CrowdsaleSession) SetEndDate(_endDate *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetEndDate(&_Crowdsale.TransactOpts, _endDate)
}

// SetEndDate is a paid mutator transaction binding the contract method 0x3784f000.
//
// Solidity: function setEndDate(uint256 _endDate) returns()
func (_Crowdsale *CrowdsaleTransactorSession) SetEndDate(_endDate *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetEndDate(&_Crowdsale.TransactOpts, _endDate)
}

// SetFrameUsd is a paid mutator transaction binding the contract method 0x0facc569.
//
// Solidity: function setFrameUsd(uint256 _frameUsd) returns()
func (_Crowdsale *CrowdsaleTransactor) SetFrameUsd(opts *bind.TransactOpts, _frameUsd *big.Int) (*types.Transaction, error) {
	return _Crowdsale.contract.Transact(opts, "setFrameUsd", _frameUsd)
}

// SetFrameUsd is a paid mutator transaction binding the contract method 0x0facc569.
//
// Solidity: function setFrameUsd(uint256 _frameUsd) returns()
func (_Crowdsale *CrowdsaleSession) SetFrameUsd(_frameUsd *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetFrameUsd(&_Crowdsale.TransactOpts, _frameUsd)
}

// SetFrameUsd is a paid mutator transaction binding the contract method 0x0facc569.
//
// Solidity: function setFrameUsd(uint256 _frameUsd) returns()
func (_Crowdsale *CrowdsaleTransactorSession) SetFrameUsd(_frameUsd *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetFrameUsd(&_Crowdsale.TransactOpts, _frameUsd)
}

// SetMaxFrames is a paid mutator transaction binding the contract method 0x3a870889.
//
// Solidity: function setMaxFrames(uint256 _maxFrames) returns()
func (_Crowdsale *CrowdsaleTransactor) SetMaxFrames(opts *bind.TransactOpts, _maxFrames *big.Int) (*types.Transaction, error) {
	return _Crowdsale.contract.Transact(opts, "setMaxFrames", _maxFrames)
}

// SetMaxFrames is a paid mutator transaction binding the contract method 0x3a870889.
//
// Solidity: function setMaxFrames(uint256 _maxFrames) returns()
func (_Crowdsale *CrowdsaleSession) SetMaxFrames(_maxFrames *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetMaxFrames(&_Crowdsale.TransactOpts, _maxFrames)
}

// SetMaxFrames is a paid mutator transaction binding the contract method 0x3a870889.
//
// Solidity: function setMaxFrames(uint256 _maxFrames) returns()
func (_Crowdsale *CrowdsaleTransactorSession) SetMaxFrames(_maxFrames *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetMaxFrames(&_Crowdsale.TransactOpts, _maxFrames)
}

// SetRoyaltyCrowdsale is a paid mutator transaction binding the contract method 0x332f0caf.
//
// Solidity: function setRoyaltyCrowdsale(address _royaltyCrowdsaleAddres) returns()
func (_Crowdsale *CrowdsaleTransactor) SetRoyaltyCrowdsale(opts *bind.TransactOpts, _royaltyCrowdsaleAddres common.Address) (*types.Transaction, error) {
	return _Crowdsale.contract.Transact(opts, "setRoyaltyCrowdsale", _royaltyCrowdsaleAddres)
}

// SetRoyaltyCrowdsale is a paid mutator transaction binding the contract method 0x332f0caf.
//
// Solidity: function setRoyaltyCrowdsale(address _royaltyCrowdsaleAddres) returns()
func (_Crowdsale *CrowdsaleSession) SetRoyaltyCrowdsale(_royaltyCrowdsaleAddres common.Address) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetRoyaltyCrowdsale(&_Crowdsale.TransactOpts, _royaltyCrowdsaleAddres)
}

// SetRoyaltyCrowdsale is a paid mutator transaction binding the contract method 0x332f0caf.
//
// Solidity: function setRoyaltyCrowdsale(address _royaltyCrowdsaleAddres) returns()
func (_Crowdsale *CrowdsaleTransactorSession) SetRoyaltyCrowdsale(_royaltyCrowdsaleAddres common.Address) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetRoyaltyCrowdsale(&_Crowdsale.TransactOpts, _royaltyCrowdsaleAddres)
}

// SetStartDate is a paid mutator transaction binding the contract method 0x82d95df5.
//
// Solidity: function setStartDate(uint256 _startDate) returns()
func (_Crowdsale *CrowdsaleTransactor) SetStartDate(opts *bind.TransactOpts, _startDate *big.Int) (*types.Transaction, error) {
	return _Crowdsale.contract.Transact(opts, "setStartDate", _startDate)
}

// SetStartDate is a paid mutator transaction binding the contract method 0x82d95df5.
//
// Solidity: function setStartDate(uint256 _startDate) returns()
func (_Crowdsale *CrowdsaleSession) SetStartDate(_startDate *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetStartDate(&_Crowdsale.TransactOpts, _startDate)
}

// SetStartDate is a paid mutator transaction binding the contract method 0x82d95df5.
//
// Solidity: function setStartDate(uint256 _startDate) returns()
func (_Crowdsale *CrowdsaleTransactorSession) SetStartDate(_startDate *big.Int) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetStartDate(&_Crowdsale.TransactOpts, _startDate)
}

// SetWallet is a paid mutator transaction binding the contract method 0xdeaa59df.
//
// Solidity: function setWallet(address _wallet) returns()
func (_Crowdsale *CrowdsaleTransactor) SetWallet(opts *bind.TransactOpts, _wallet common.Address) (*types.Transaction, error) {
	return _Crowdsale.contract.Transact(opts, "setWallet", _wallet)
}

// SetWallet is a paid mutator transaction binding the contract method 0xdeaa59df.
//
// Solidity: function setWallet(address _wallet) returns()
func (_Crowdsale *CrowdsaleSession) SetWallet(_wallet common.Address) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetWallet(&_Crowdsale.TransactOpts, _wallet)
}

// SetWallet is a paid mutator transaction binding the contract method 0xdeaa59df.
//
// Solidity: function setWallet(address _wallet) returns()
func (_Crowdsale *CrowdsaleTransactorSession) SetWallet(_wallet common.Address) (*types.Transaction, error) {
	return _Crowdsale.Contract.SetWallet(&_Crowdsale.TransactOpts, _wallet)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address _newOwner) returns()
func (_Crowdsale *CrowdsaleTransactor) TransferOwnership(opts *bind.TransactOpts, _newOwner common.Address) (*types.Transaction, error) {
	return _Crowdsale.contract.Transact(opts, "transferOwnership", _newOwner)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address _newOwner) returns()
func (_Crowdsale *CrowdsaleSession) TransferOwnership(_newOwner common.Address) (*types.Transaction, error) {
	return _Crowdsale.Contract.TransferOwnership(&_Crowdsale.TransactOpts, _newOwner)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address _newOwner) returns()
func (_Crowdsale *CrowdsaleTransactorSession) TransferOwnership(_newOwner common.Address) (*types.Transaction, error) {
	return _Crowdsale.Contract.TransferOwnership(&_Crowdsale.TransactOpts, _newOwner)
}

// TransferOwnershipImmediately is a paid mutator transaction binding the contract method 0x7e71fb09.
//
// Solidity: function transferOwnershipImmediately(address _newOwner) returns()
func (_Crowdsale *CrowdsaleTransactor) TransferOwnershipImmediately(opts *bind.TransactOpts, _newOwner common.Address) (*types.Transaction, error) {
	return _Crowdsale.contract.Transact(opts, "transferOwnershipImmediately", _newOwner)
}

// TransferOwnershipImmediately is a paid mutator transaction binding the contract method 0x7e71fb09.
//
// Solidity: function transferOwnershipImmediately(address _newOwner) returns()
func (_Crowdsale *CrowdsaleSession) TransferOwnershipImmediately(_newOwner common.Address) (*types.Transaction, error) {
	return _Crowdsale.Contract.TransferOwnershipImmediately(&_Crowdsale.TransactOpts, _newOwner)
}

// TransferOwnershipImmediately is a paid mutator transaction binding the contract method 0x7e71fb09.
//
// Solidity: function transferOwnershipImmediately(address _newOwner) returns()
func (_Crowdsale *CrowdsaleTransactorSession) TransferOwnershipImmediately(_newOwner common.Address) (*types.Transaction, error) {
	return _Crowdsale.Contract.TransferOwnershipImmediately(&_Crowdsale.TransactOpts, _newOwner)
}

// CrowdsaleBonusOffListUpdatedIterator is returned from FilterBonusOffListUpdated and is used to iterate over the raw logs and unpacked data for BonusOffListUpdated events raised by the Crowdsale contract.
type CrowdsaleBonusOffListUpdatedIterator struct {
	Event *CrowdsaleBonusOffListUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrowdsaleBonusOffListUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrowdsaleBonusOffListUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrowdsaleBonusOffListUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrowdsaleBonusOffListUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrowdsaleBonusOffListUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrowdsaleBonusOffListUpdated represents a BonusOffListUpdated event raised by the Crowdsale contract.
type CrowdsaleBonusOffListUpdated struct {
	OldBonusOffList *big.Int
	NewBonusOffList *big.Int
	Raw             types.Log // Blockchain specific contextual infos
}

// FilterBonusOffListUpdated is a free log retrieval operation binding the contract event 0xe41ec0912cab1c7fd7711b6e297053371ece6417eec95a095ed1408186094702.
//
// Solidity: event BonusOffListUpdated(uint256 oldBonusOffList, uint256 newBonusOffList)
func (_Crowdsale *CrowdsaleFilterer) FilterBonusOffListUpdated(opts *bind.FilterOpts) (*CrowdsaleBonusOffListUpdatedIterator, error) {

	logs, sub, err := _Crowdsale.contract.FilterLogs(opts, "BonusOffListUpdated")
	if err != nil {
		return nil, err
	}
	return &CrowdsaleBonusOffListUpdatedIterator{contract: _Crowdsale.contract, event: "BonusOffListUpdated", logs: logs, sub: sub}, nil
}

// WatchBonusOffListUpdated is a free log subscription operation binding the contract event 0xe41ec0912cab1c7fd7711b6e297053371ece6417eec95a095ed1408186094702.
//
// Solidity: event BonusOffListUpdated(uint256 oldBonusOffList, uint256 newBonusOffList)
func (_Crowdsale *CrowdsaleFilterer) WatchBonusOffListUpdated(opts *bind.WatchOpts, sink chan<- *CrowdsaleBonusOffListUpdated) (event.Subscription, error) {

	logs, sub, err := _Crowdsale.contract.WatchLogs(opts, "BonusOffListUpdated")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrowdsaleBonusOffListUpdated)
				if err := _Crowdsale.contract.UnpackLog(event, "BonusOffListUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// CrowdsaleEndDateUpdatedIterator is returned from FilterEndDateUpdated and is used to iterate over the raw logs and unpacked data for EndDateUpdated events raised by the Crowdsale contract.
type CrowdsaleEndDateUpdatedIterator struct {
	Event *CrowdsaleEndDateUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrowdsaleEndDateUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrowdsaleEndDateUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrowdsaleEndDateUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrowdsaleEndDateUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrowdsaleEndDateUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrowdsaleEndDateUpdated represents a EndDateUpdated event raised by the Crowdsale contract.
type CrowdsaleEndDateUpdated struct {
	OldEndDate *big.Int
	NewEndDate *big.Int
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterEndDateUpdated is a free log retrieval operation binding the contract event 0x275dd536a6956e78302b90e20bb13c379fb11632284794aa77ad452d0f472a15.
//
// Solidity: event EndDateUpdated(uint256 oldEndDate, uint256 newEndDate)
func (_Crowdsale *CrowdsaleFilterer) FilterEndDateUpdated(opts *bind.FilterOpts) (*CrowdsaleEndDateUpdatedIterator, error) {

	logs, sub, err := _Crowdsale.contract.FilterLogs(opts, "EndDateUpdated")
	if err != nil {
		return nil, err
	}
	return &CrowdsaleEndDateUpdatedIterator{contract: _Crowdsale.contract, event: "EndDateUpdated", logs: logs, sub: sub}, nil
}

// WatchEndDateUpdated is a free log subscription operation binding the contract event 0x275dd536a6956e78302b90e20bb13c379fb11632284794aa77ad452d0f472a15.
//
// Solidity: event EndDateUpdated(uint256 oldEndDate, uint256 newEndDate)
func (_Crowdsale *CrowdsaleFilterer) WatchEndDateUpdated(opts *bind.WatchOpts, sink chan<- *CrowdsaleEndDateUpdated) (event.Subscription, error) {

	logs, sub, err := _Crowdsale.contract.WatchLogs(opts, "EndDateUpdated")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrowdsaleEndDateUpdated)
				if err := _Crowdsale.contract.UnpackLog(event, "EndDateUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// CrowdsaleFrameUsdUpdatedIterator is returned from FilterFrameUsdUpdated and is used to iterate over the raw logs and unpacked data for FrameUsdUpdated events raised by the Crowdsale contract.
type CrowdsaleFrameUsdUpdatedIterator struct {
	Event *CrowdsaleFrameUsdUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrowdsaleFrameUsdUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrowdsaleFrameUsdUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrowdsaleFrameUsdUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrowdsaleFrameUsdUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrowdsaleFrameUsdUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrowdsaleFrameUsdUpdated represents a FrameUsdUpdated event raised by the Crowdsale contract.
type CrowdsaleFrameUsdUpdated struct {
	OldFrameUsd *big.Int
	NewFrameUsd *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterFrameUsdUpdated is a free log retrieval operation binding the contract event 0x60703fd984c32f85e124174cd942f47d0a964644caa65969ad611920970d63c1.
//
// Solidity: event FrameUsdUpdated(uint256 oldFrameUsd, uint256 newFrameUsd)
func (_Crowdsale *CrowdsaleFilterer) FilterFrameUsdUpdated(opts *bind.FilterOpts) (*CrowdsaleFrameUsdUpdatedIterator, error) {

	logs, sub, err := _Crowdsale.contract.FilterLogs(opts, "FrameUsdUpdated")
	if err != nil {
		return nil, err
	}
	return &CrowdsaleFrameUsdUpdatedIterator{contract: _Crowdsale.contract, event: "FrameUsdUpdated", logs: logs, sub: sub}, nil
}

// WatchFrameUsdUpdated is a free log subscription operation binding the contract event 0x60703fd984c32f85e124174cd942f47d0a964644caa65969ad611920970d63c1.
//
// Solidity: event FrameUsdUpdated(uint256 oldFrameUsd, uint256 newFrameUsd)
func (_Crowdsale *CrowdsaleFilterer) WatchFrameUsdUpdated(opts *bind.WatchOpts, sink chan<- *CrowdsaleFrameUsdUpdated) (event.Subscription, error) {

	logs, sub, err := _Crowdsale.contract.WatchLogs(opts, "FrameUsdUpdated")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrowdsaleFrameUsdUpdated)
				if err := _Crowdsale.contract.UnpackLog(event, "FrameUsdUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// CrowdsaleMaxFramesUpdatedIterator is returned from FilterMaxFramesUpdated and is used to iterate over the raw logs and unpacked data for MaxFramesUpdated events raised by the Crowdsale contract.
type CrowdsaleMaxFramesUpdatedIterator struct {
	Event *CrowdsaleMaxFramesUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrowdsaleMaxFramesUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrowdsaleMaxFramesUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrowdsaleMaxFramesUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrowdsaleMaxFramesUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrowdsaleMaxFramesUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrowdsaleMaxFramesUpdated represents a MaxFramesUpdated event raised by the Crowdsale contract.
type CrowdsaleMaxFramesUpdated struct {
	OldMaxFrames *big.Int
	NewMaxFrames *big.Int
	Raw          types.Log // Blockchain specific contextual infos
}

// FilterMaxFramesUpdated is a free log retrieval operation binding the contract event 0xb14a5e8204c3ba85188ab2ed91907c2763525b9d1ba0386d02e3e4fa2892ce1e.
//
// Solidity: event MaxFramesUpdated(uint256 oldMaxFrames, uint256 newMaxFrames)
func (_Crowdsale *CrowdsaleFilterer) FilterMaxFramesUpdated(opts *bind.FilterOpts) (*CrowdsaleMaxFramesUpdatedIterator, error) {

	logs, sub, err := _Crowdsale.contract.FilterLogs(opts, "MaxFramesUpdated")
	if err != nil {
		return nil, err
	}
	return &CrowdsaleMaxFramesUpdatedIterator{contract: _Crowdsale.contract, event: "MaxFramesUpdated", logs: logs, sub: sub}, nil
}

// WatchMaxFramesUpdated is a free log subscription operation binding the contract event 0xb14a5e8204c3ba85188ab2ed91907c2763525b9d1ba0386d02e3e4fa2892ce1e.
//
// Solidity: event MaxFramesUpdated(uint256 oldMaxFrames, uint256 newMaxFrames)
func (_Crowdsale *CrowdsaleFilterer) WatchMaxFramesUpdated(opts *bind.WatchOpts, sink chan<- *CrowdsaleMaxFramesUpdated) (event.Subscription, error) {

	logs, sub, err := _Crowdsale.contract.WatchLogs(opts, "MaxFramesUpdated")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrowdsaleMaxFramesUpdated)
				if err := _Crowdsale.contract.UnpackLog(event, "MaxFramesUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// CrowdsaleOwnershipTransferredIterator is returned from FilterOwnershipTransferred and is used to iterate over the raw logs and unpacked data for OwnershipTransferred events raised by the Crowdsale contract.
type CrowdsaleOwnershipTransferredIterator struct {
	Event *CrowdsaleOwnershipTransferred // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrowdsaleOwnershipTransferredIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrowdsaleOwnershipTransferred)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrowdsaleOwnershipTransferred)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrowdsaleOwnershipTransferredIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrowdsaleOwnershipTransferredIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrowdsaleOwnershipTransferred represents a OwnershipTransferred event raised by the Crowdsale contract.
type CrowdsaleOwnershipTransferred struct {
	From common.Address
	To   common.Address
	Raw  types.Log // Blockchain specific contextual infos
}

// FilterOwnershipTransferred is a free log retrieval operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed _from, address indexed _to)
func (_Crowdsale *CrowdsaleFilterer) FilterOwnershipTransferred(opts *bind.FilterOpts, _from []common.Address, _to []common.Address) (*CrowdsaleOwnershipTransferredIterator, error) {

	var _fromRule []interface{}
	for _, _fromItem := range _from {
		_fromRule = append(_fromRule, _fromItem)
	}
	var _toRule []interface{}
	for _, _toItem := range _to {
		_toRule = append(_toRule, _toItem)
	}

	logs, sub, err := _Crowdsale.contract.FilterLogs(opts, "OwnershipTransferred", _fromRule, _toRule)
	if err != nil {
		return nil, err
	}
	return &CrowdsaleOwnershipTransferredIterator{contract: _Crowdsale.contract, event: "OwnershipTransferred", logs: logs, sub: sub}, nil
}

// WatchOwnershipTransferred is a free log subscription operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed _from, address indexed _to)
func (_Crowdsale *CrowdsaleFilterer) WatchOwnershipTransferred(opts *bind.WatchOpts, sink chan<- *CrowdsaleOwnershipTransferred, _from []common.Address, _to []common.Address) (event.Subscription, error) {

	var _fromRule []interface{}
	for _, _fromItem := range _from {
		_fromRule = append(_fromRule, _fromItem)
	}
	var _toRule []interface{}
	for _, _toItem := range _to {
		_toRule = append(_toRule, _toItem)
	}

	logs, sub, err := _Crowdsale.contract.WatchLogs(opts, "OwnershipTransferred", _fromRule, _toRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrowdsaleOwnershipTransferred)
				if err := _Crowdsale.contract.UnpackLog(event, "OwnershipTransferred", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// CrowdsalePurchasedIterator is returned from FilterPurchased and is used to iterate over the raw logs and unpacked data for Purchased events raised by the Crowdsale contract.
type CrowdsalePurchasedIterator struct {
	Event *CrowdsalePurchased // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrowdsalePurchasedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrowdsalePurchased)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrowdsalePurchased)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrowdsalePurchasedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrowdsalePurchasedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrowdsalePurchased represents a Purchased event raised by the Crowdsale contract.
type CrowdsalePurchased struct {
	Addr           common.Address
	Frames         *big.Int
	EthToTransfer  *big.Int
	FramesSold     *big.Int
	ContributedEth *big.Int
	Raw            types.Log // Blockchain specific contextual infos
}

// FilterPurchased is a free log retrieval operation binding the contract event 0x5f5252e81556cf80e49da97ac40f17af2fb3b00e318b675ae93089f555bfa380.
//
// Solidity: event Purchased(address indexed addr, uint256 frames, uint256 ethToTransfer, uint256 framesSold, uint256 contributedEth)
func (_Crowdsale *CrowdsaleFilterer) FilterPurchased(opts *bind.FilterOpts, addr []common.Address) (*CrowdsalePurchasedIterator, error) {

	var addrRule []interface{}
	for _, addrItem := range addr {
		addrRule = append(addrRule, addrItem)
	}

	logs, sub, err := _Crowdsale.contract.FilterLogs(opts, "Purchased", addrRule)
	if err != nil {
		return nil, err
	}
	return &CrowdsalePurchasedIterator{contract: _Crowdsale.contract, event: "Purchased", logs: logs, sub: sub}, nil
}

// WatchPurchased is a free log subscription operation binding the contract event 0x5f5252e81556cf80e49da97ac40f17af2fb3b00e318b675ae93089f555bfa380.
//
// Solidity: event Purchased(address indexed addr, uint256 frames, uint256 ethToTransfer, uint256 framesSold, uint256 contributedEth)
func (_Crowdsale *CrowdsaleFilterer) WatchPurchased(opts *bind.WatchOpts, sink chan<- *CrowdsalePurchased, addr []common.Address) (event.Subscription, error) {

	var addrRule []interface{}
	for _, addrItem := range addr {
		addrRule = append(addrRule, addrItem)
	}

	logs, sub, err := _Crowdsale.contract.WatchLogs(opts, "Purchased", addrRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrowdsalePurchased)
				if err := _Crowdsale.contract.UnpackLog(event, "Purchased", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// CrowdsaleRoyaltyCrowdsaleUpdatedIterator is returned from FilterRoyaltyCrowdsaleUpdated and is used to iterate over the raw logs and unpacked data for RoyaltyCrowdsaleUpdated events raised by the Crowdsale contract.
type CrowdsaleRoyaltyCrowdsaleUpdatedIterator struct {
	Event *CrowdsaleRoyaltyCrowdsaleUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrowdsaleRoyaltyCrowdsaleUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrowdsaleRoyaltyCrowdsaleUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrowdsaleRoyaltyCrowdsaleUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrowdsaleRoyaltyCrowdsaleUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrowdsaleRoyaltyCrowdsaleUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrowdsaleRoyaltyCrowdsaleUpdated represents a RoyaltyCrowdsaleUpdated event raised by the Crowdsale contract.
type CrowdsaleRoyaltyCrowdsaleUpdated struct {
	OldRoyaltyCrowdsaleAddress common.Address
	NewRoyaltyCrowdsaleAddres  common.Address
	Raw                        types.Log // Blockchain specific contextual infos
}

// FilterRoyaltyCrowdsaleUpdated is a free log retrieval operation binding the contract event 0x7308dd53500811502754bb0c8836b26a7f66dddf459554a5cd6544f388a4b5e2.
//
// Solidity: event RoyaltyCrowdsaleUpdated(address indexed oldRoyaltyCrowdsaleAddress, address indexed newRoyaltyCrowdsaleAddres)
func (_Crowdsale *CrowdsaleFilterer) FilterRoyaltyCrowdsaleUpdated(opts *bind.FilterOpts, oldRoyaltyCrowdsaleAddress []common.Address, newRoyaltyCrowdsaleAddres []common.Address) (*CrowdsaleRoyaltyCrowdsaleUpdatedIterator, error) {

	var oldRoyaltyCrowdsaleAddressRule []interface{}
	for _, oldRoyaltyCrowdsaleAddressItem := range oldRoyaltyCrowdsaleAddress {
		oldRoyaltyCrowdsaleAddressRule = append(oldRoyaltyCrowdsaleAddressRule, oldRoyaltyCrowdsaleAddressItem)
	}
	var newRoyaltyCrowdsaleAddresRule []interface{}
	for _, newRoyaltyCrowdsaleAddresItem := range newRoyaltyCrowdsaleAddres {
		newRoyaltyCrowdsaleAddresRule = append(newRoyaltyCrowdsaleAddresRule, newRoyaltyCrowdsaleAddresItem)
	}

	logs, sub, err := _Crowdsale.contract.FilterLogs(opts, "RoyaltyCrowdsaleUpdated", oldRoyaltyCrowdsaleAddressRule, newRoyaltyCrowdsaleAddresRule)
	if err != nil {
		return nil, err
	}
	return &CrowdsaleRoyaltyCrowdsaleUpdatedIterator{contract: _Crowdsale.contract, event: "RoyaltyCrowdsaleUpdated", logs: logs, sub: sub}, nil
}

// WatchRoyaltyCrowdsaleUpdated is a free log subscription operation binding the contract event 0x7308dd53500811502754bb0c8836b26a7f66dddf459554a5cd6544f388a4b5e2.
//
// Solidity: event RoyaltyCrowdsaleUpdated(address indexed oldRoyaltyCrowdsaleAddress, address indexed newRoyaltyCrowdsaleAddres)
func (_Crowdsale *CrowdsaleFilterer) WatchRoyaltyCrowdsaleUpdated(opts *bind.WatchOpts, sink chan<- *CrowdsaleRoyaltyCrowdsaleUpdated, oldRoyaltyCrowdsaleAddress []common.Address, newRoyaltyCrowdsaleAddres []common.Address) (event.Subscription, error) {

	var oldRoyaltyCrowdsaleAddressRule []interface{}
	for _, oldRoyaltyCrowdsaleAddressItem := range oldRoyaltyCrowdsaleAddress {
		oldRoyaltyCrowdsaleAddressRule = append(oldRoyaltyCrowdsaleAddressRule, oldRoyaltyCrowdsaleAddressItem)
	}
	var newRoyaltyCrowdsaleAddresRule []interface{}
	for _, newRoyaltyCrowdsaleAddresItem := range newRoyaltyCrowdsaleAddres {
		newRoyaltyCrowdsaleAddresRule = append(newRoyaltyCrowdsaleAddresRule, newRoyaltyCrowdsaleAddresItem)
	}

	logs, sub, err := _Crowdsale.contract.WatchLogs(opts, "RoyaltyCrowdsaleUpdated", oldRoyaltyCrowdsaleAddressRule, newRoyaltyCrowdsaleAddresRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrowdsaleRoyaltyCrowdsaleUpdated)
				if err := _Crowdsale.contract.UnpackLog(event, "RoyaltyCrowdsaleUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// CrowdsaleStartDateUpdatedIterator is returned from FilterStartDateUpdated and is used to iterate over the raw logs and unpacked data for StartDateUpdated events raised by the Crowdsale contract.
type CrowdsaleStartDateUpdatedIterator struct {
	Event *CrowdsaleStartDateUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrowdsaleStartDateUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrowdsaleStartDateUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrowdsaleStartDateUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrowdsaleStartDateUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrowdsaleStartDateUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrowdsaleStartDateUpdated represents a StartDateUpdated event raised by the Crowdsale contract.
type CrowdsaleStartDateUpdated struct {
	OldStartDate *big.Int
	NewStartDate *big.Int
	Raw          types.Log // Blockchain specific contextual infos
}

// FilterStartDateUpdated is a free log retrieval operation binding the contract event 0xb412a2d7de723b82b0a3cae8b10ae2d255e645dd0231a1a4c83cb8e3ebc05bd8.
//
// Solidity: event StartDateUpdated(uint256 oldStartDate, uint256 newStartDate)
func (_Crowdsale *CrowdsaleFilterer) FilterStartDateUpdated(opts *bind.FilterOpts) (*CrowdsaleStartDateUpdatedIterator, error) {

	logs, sub, err := _Crowdsale.contract.FilterLogs(opts, "StartDateUpdated")
	if err != nil {
		return nil, err
	}
	return &CrowdsaleStartDateUpdatedIterator{contract: _Crowdsale.contract, event: "StartDateUpdated", logs: logs, sub: sub}, nil
}

// WatchStartDateUpdated is a free log subscription operation binding the contract event 0xb412a2d7de723b82b0a3cae8b10ae2d255e645dd0231a1a4c83cb8e3ebc05bd8.
//
// Solidity: event StartDateUpdated(uint256 oldStartDate, uint256 newStartDate)
func (_Crowdsale *CrowdsaleFilterer) WatchStartDateUpdated(opts *bind.WatchOpts, sink chan<- *CrowdsaleStartDateUpdated) (event.Subscription, error) {

	logs, sub, err := _Crowdsale.contract.WatchLogs(opts, "StartDateUpdated")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrowdsaleStartDateUpdated)
				if err := _Crowdsale.contract.UnpackLog(event, "StartDateUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// CrowdsaleWalletUpdatedIterator is returned from FilterWalletUpdated and is used to iterate over the raw logs and unpacked data for WalletUpdated events raised by the Crowdsale contract.
type CrowdsaleWalletUpdatedIterator struct {
	Event *CrowdsaleWalletUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrowdsaleWalletUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrowdsaleWalletUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrowdsaleWalletUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrowdsaleWalletUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrowdsaleWalletUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrowdsaleWalletUpdated represents a WalletUpdated event raised by the Crowdsale contract.
type CrowdsaleWalletUpdated struct {
	OldWallet common.Address
	NewWallet common.Address
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterWalletUpdated is a free log retrieval operation binding the contract event 0x0f37c6733428a3a65d46b7f1853a5ce4bfa3cf92d25322507a50bf23a0b5a0a8.
//
// Solidity: event WalletUpdated(address indexed oldWallet, address indexed newWallet)
func (_Crowdsale *CrowdsaleFilterer) FilterWalletUpdated(opts *bind.FilterOpts, oldWallet []common.Address, newWallet []common.Address) (*CrowdsaleWalletUpdatedIterator, error) {

	var oldWalletRule []interface{}
	for _, oldWalletItem := range oldWallet {
		oldWalletRule = append(oldWalletRule, oldWalletItem)
	}
	var newWalletRule []interface{}
	for _, newWalletItem := range newWallet {
		newWalletRule = append(newWalletRule, newWalletItem)
	}

	logs, sub, err := _Crowdsale.contract.FilterLogs(opts, "WalletUpdated", oldWalletRule, newWalletRule)
	if err != nil {
		return nil, err
	}
	return &CrowdsaleWalletUpdatedIterator{contract: _Crowdsale.contract, event: "WalletUpdated", logs: logs, sub: sub}, nil
}

// WatchWalletUpdated is a free log subscription operation binding the contract event 0x0f37c6733428a3a65d46b7f1853a5ce4bfa3cf92d25322507a50bf23a0b5a0a8.
//
// Solidity: event WalletUpdated(address indexed oldWallet, address indexed newWallet)
func (_Crowdsale *CrowdsaleFilterer) WatchWalletUpdated(opts *bind.WatchOpts, sink chan<- *CrowdsaleWalletUpdated, oldWallet []common.Address, newWallet []common.Address) (event.Subscription, error) {

	var oldWalletRule []interface{}
	for _, oldWalletItem := range oldWallet {
		oldWalletRule = append(oldWalletRule, oldWalletItem)
	}
	var newWalletRule []interface{}
	for _, newWalletItem := range newWallet {
		newWalletRule = append(newWalletRule, newWalletItem)
	}

	logs, sub, err := _Crowdsale.contract.WatchLogs(opts, "WalletUpdated", oldWalletRule, newWalletRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrowdsaleWalletUpdated)
				if err := _Crowdsale.contract.UnpackLog(event, "WalletUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}
