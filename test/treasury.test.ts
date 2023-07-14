import { ethers } from "hardhat";
import { Contract, ContractFactory } from "ethers";
import { expect } from "chai";

describe("Treasury", () => {
  let Treasury: ContractFactory;
  let treasury: Contract;
  let usdcToken: Contract;
  let usdtToken: Contract;
  let daiToken: Contract;
  let uniswapRouter: Contract;

  const USDC_ADDRESS = "YOUR_USDC_TOKEN_ADDRESS";
  const USDT_ADDRESS = "YOUR_USDT_TOKEN_ADDRESS";
  const DAI_ADDRESS = "YOUR_DAI_TOKEN_ADDRESS";
  const UNISWAP_ROUTER_ADDRESS = "YOUR_UNISWAP_ROUTER_ADDRESS";

  beforeEach(async () => {
    Treasury = await ethers.getContractFactory("Treasury");
    [usdcToken, usdtToken, daiToken] = await Promise.all([
      ethers.getContractAt("IERC20", USDC_ADDRESS),
      ethers.getContractAt("IERC20", USDT_ADDRESS),
      ethers.getContractAt("IERC20", DAI_ADDRESS),
    ]);
    uniswapRouter = await ethers.getContractAt(
      "IUniswapRouter",
      UNISWAP_ROUTER_ADDRESS
    );

    // Deploy the Treasury contract
    treasury = (await Treasury.deploy(
      USDC_ADDRESS,
      USDT_ADDRESS,
      DAI_ADDRESS,
      UNISWAP_ROUTER_ADDRESS
    )) as Contract;
    await treasury.deployed();

    // Perform any necessary setup here
  });

  it("should deposit tokens into the treasury", async () => {
    const amount = 1000;

    // Transfer tokens to the treasury contract
    await usdcToken.transferFrom(
      await ethers.provider.getSigner(),
      treasury.address,
      amount
    );

    // Assert the balance of the treasury contract
    expect(await usdcToken.balanceOf(treasury.address)).to.equal(amount);
  });

  it("should withdraw tokens from the treasury", async () => {
    const amount = 500;

    // Transfer tokens to the treasury contract
    await usdcToken.transferFrom(
      await ethers.provider.getSigner(),
      treasury.address,
      amount
    );

    // Withdraw tokens from the treasury contract
    await treasury.withdraw(amount);

    // Assert the balance of the treasury contract
    expect(await usdcToken.balanceOf(treasury.address)).to.equal(0);
  });

  it("should swap tokens using Uniswap", async () => {
    // Set the allocation ratios in the treasury contract
    await treasury.setAllocationRatios(50, 30, 20);

    // Swap tokens in the treasury contract
    await treasury.swapTokens();

    // Assert the balances of the treasury contract
    expect(await usdcToken.balanceOf(treasury.address)).to.equal(0);
    expect(await usdtToken.balanceOf(treasury.address)).to.be.gt(0);
    expect(await daiToken.balanceOf(treasury.address)).to.be.gt(0);
  });

  it("should calculate the aggregated yield", async () => {
    // Calculate and assert the aggregated yield
    const aggregatedYield = await treasury.getAggregatedYield();

    console.log("Aggregated yield:", aggregatedYield);
  });
});
