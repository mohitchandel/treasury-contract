const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log(
    "Deploying Treasury contract with the account:",
    deployer.address
  );

  const usdcTokenAddress = "YOUR_USDC_TOKEN_ADDRESS";
  const usdtTokenAddress = "YOUR_USDT_TOKEN_ADDRESS";
  const daiTokenAddress = "YOUR_DAI_TOKEN_ADDRESS";
  const uniswapRouterAddress = "YOUR_UNISWAP_ROUTER_ADDRESS";

  const Treasury = await hre.ethers.getContractFactory("Treasury");
  const treasury = await Treasury.deploy(
    usdcTokenAddress,
    usdtTokenAddress,
    daiTokenAddress,
    uniswapRouterAddress
  );

  await treasury.deployed();

  console.log("Treasury contract deployed to:", treasury.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
