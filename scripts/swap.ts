import { ethers } from "hardhat";

async function main() {
  // network -> forked mainnet
  const marketAddr = "0x4bf010f1b9beDA5450a8dD702ED602A104ff65EE";
  const market = await ethers.getContractAt("Market", marketAddr);
  console.log("Market fromToken:", await market.fromToken());
  console.log("Market toToken:", await market.toToken());
  const batAmount = "2";
  const usdAmount = "1";
  // @ts-ignore
  let { _price, _priceDecimals, _result, _route } = await market.getQuote(
    "BAT",
    "USDC",
    batAmount
  );

  console.log("Quote from 1BAT to 1USDC: ", {
    price: _price.toNumber(),
    priceDecimals: _priceDecimals,
    result: _result.toNumber(),
    route: _route,
  });

  // @ts-ignore
  { _price, _priceDecimals, _result, _route } = await market.getQuote(
    "USDC",
    "BAT",
    usdAmount
  );

  console.log("Quote from 1USDC to 1BAT: ", {
    price: _price.toNumber(),
    priceDecimals: _priceDecimals,
    result: _result.toNumber(),
    route: _route,
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
