import { ethers } from "hardhat";

async function main() {
  // network -> forked mainnet
  const Market = await ethers.getContractFactory("Market");
  const fromAddr = "0x0D8775F648430679A709E98d2b0Cb6250d2887EF"; // BAT
  const toAddr = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"; // USDC
  const aggrAddr = "0x9441D7556e7820B5ca42082cfa99487D56AcA958"; // BAT/USDC aggregator

  const market = await Market.deploy(fromAddr, toAddr, aggrAddr);

  await market.deployed();

  console.log("Market deployed to:", market.address);
  // 0x4bf010f1b9beDA5450a8dD702ED602A104ff65EE
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
