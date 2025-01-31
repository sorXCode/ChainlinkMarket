# ChainLinkV2 Market

This contract uses chainlink v2 pricefeed to create a market for token pairs. The market allow any address to swap from token A to token B permissionlessly
given that Token A and Token B are supported by chainlink price feeds on chosen network

## Dependencies

- yarn
- node v16
- hardhat
- ethers.js

## Features

- Allows customization of tokens and aggregation
- Automatically fetches tokens symbols at intialization
- Allows quote-fetching(getQuotes) for token pairs prior to exchange using just token-pair symbols and amount
- Allows two-ways token-pair swapping



## Tech Stack
- **Solidity** – Smart contract development
- **Hardhat** – Testing and deployment framework
- **Chainlink Oracles** – Secure and decentralized price feeds
- **Ethereum & EVM-Compatible Chains** – Deployable on various networks


## Installation


Clone the repository:
```sh
git clone https://github.com/sorXCode/ChainlinkMarket.git
cd ChainlinkMarket
```


Install dependencies:
```sh
yarn install
```


## Deployment


Compile the smart contracts:
```sh
npx hardhat compile
```


Run tests:
```sh
npx hardhat test
```


Deploy to a local blockchain:
```sh
npx hardhat node
npx hardhat run scripts/deploy.ts --network localhost
```


Deploy to a testnet:
```sh
npx hardhat run scripts/deploy.ts --network ropsten
```
