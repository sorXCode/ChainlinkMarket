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

