# Treasury Smart Contract

The Treasury Smart Contract is a decentralized finance (DeFi) contract that allows for the management and allocation of funds across different liquidity pools and DeFi protocols. It enables users to deposit stablecoins, such as USDC, and dynamically allocate the funds to different protocols based on specified ratios. The contract supports swapping of funds using Uniswap, and it calculates the aggregated percentage yield of all the protocols.

## Features

- Deposit stablecoins (e.g., USDC) into the Treasury contract
- Set allocation ratios for funds across different protocols
- Swap funds between stablecoins using Uniswap
- Withdraw funds from the Treasury contract
- Calculate the aggregated percentage yield of all the protocols

## Requirements

- Node.js
- Hardhat
- Solidity
- TypeScript

## Installation

1. Clone the repository:

```shell
git clone https://github.com/mohitchandel/treasury-contract.git
```

2. Install dependencies

```shell
cd treasury-contract
npm install
```

## Configure the project

- Update the contract addresses in the test script (test/treasury.test.ts) with the actual addresses of the deployed contracts.
- Update the deploy script (scripts/deploy.ts) with the correct contract names and parameters.

## Usage

- Compile the contracts: `npx hardhat compile`
- Run the tests: `npx hardhat test`
- Deploy the contracts: `npx hardhat run scripts/deploy.ts`
