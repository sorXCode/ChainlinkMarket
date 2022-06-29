import { expect } from "chai";
import { assert } from "console";
import { ethers } from "hardhat";

describe("Greeter", function () {
  it("Should log name", async function () {
    const name = "unknown";
    console.log(name);
    expect(name).to.not.equal("unknown");
  });
});
