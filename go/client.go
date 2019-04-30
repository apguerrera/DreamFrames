package main

import (
    "fmt"
    "log"

    "github.com/ethereum/go-ethereum/common"
    "github.com/ethereum/go-ethereum/ethclient"

    crowdsale "crowdsale" // AG: Not working for the import of local files
)

func main() {
    client, err := ethclient.Dial("https://ropsten.infura.io/v3/4c426919f9d2465f803710f94b254734")
    if err != nil {
        log.Fatal(err)
    }

    address := common.HexToAddress("0x738Cd40eCc5946C3F1947f6d472D5A1bEC5EfdB8")  // AG: Contract Address
    instance, err := crowdsale.NewCrowdsale(address, client)
    if err != nil {
        log.Fatal(err)
    }

    pctRemaining, err := instance.PctRemaining(nil)
    if err != nil {
        log.Fatal(err)
    }

    fmt.Println(pctRemaining) // "1.0"
}
