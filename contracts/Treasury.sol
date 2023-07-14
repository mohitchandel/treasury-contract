// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Interfaces/IERC20.sol";
import "./Interfaces/IUniswapRouter.sol";

contract Treasury {
    address private owner;
    address private usdcTokenAddress; // USDC token contract address
    address private usdtTokenAddress; // USDT token contract address
    address private daiTokenAddress; // DAI token contract address
    address private uniswapRouterAddress; // Uniswap V2 Router contract address

    uint256 private usdcAllocationRatio; // Allocation ratio for USDC
    uint256 private usdtAllocationRatio; // Allocation ratio for USDT
    uint256 private daiAllocationRatio; // Allocation ratio for DAI

    // Event emitted when funds are deposited
    event Deposit(address indexed from, uint256 amount);

    // Event emitted when funds are withdrawn
    event Withdrawal(address indexed to, uint256 amount);

    constructor(
        address _usdcTokenAddress,
        address _usdtTokenAddress,
        address _daiTokenAddress,
        address _uniswapRouterAddress
    ) {
        owner = msg.sender;
        usdcTokenAddress = _usdcTokenAddress;
        usdtTokenAddress = _usdtTokenAddress;
        daiTokenAddress = _daiTokenAddress;
        uniswapRouterAddress = _uniswapRouterAddress;
    }

    // Modifier to ensure only the owner can call certain functions
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    // Deposit funds into the treasury contract
    function deposit(uint256 amount) external {
        IERC20 usdcToken = IERC20(usdcTokenAddress);

        require(
            usdcToken.transferFrom(msg.sender, address(this), amount),
            "Failed to transfer USDC"
        );
        emit Deposit(msg.sender, amount);
    }

    // Withdraw funds from the treasury contract
    function withdraw(uint256 amount) external onlyOwner {
        IERC20 usdcToken = IERC20(usdcTokenAddress);
        require(
            usdcToken.balanceOf(address(this)) >= amount,
            "Insufficient USDC balance"
        );

        require(
            usdcToken.transfer(msg.sender, amount),
            "Failed to transfer USDC"
        );
        emit Withdrawal(msg.sender, amount);
    }

    // Set the allocation ratios for USDC, USDT, and DAI
    function setAllocationRatios(
        uint256 _usdcAllocationRatio,
        uint256 _usdtAllocationRatio,
        uint256 _daiAllocationRatio
    ) external onlyOwner {
        require(
            _usdcAllocationRatio + _usdtAllocationRatio + _daiAllocationRatio ==
                100,
            "Allocation ratios must add up to 100"
        );

        usdcAllocationRatio = _usdcAllocationRatio;
        usdtAllocationRatio = _usdtAllocationRatio;
        daiAllocationRatio = _daiAllocationRatio;
    }

    // Swap allocated funds between different tokens using Uniswap
    function swapTokens() external onlyOwner {
        IERC20 usdcToken = IERC20(usdcTokenAddress);
        IERC20 usdtToken = IERC20(usdtTokenAddress);
        IERC20 daiToken = IERC20(daiTokenAddress);
        IUniswapRouter uniswapRouter = IUniswapRouter(uniswapRouterAddress);

        uint256 usdcBalance = usdcToken.balanceOf(address(this));
        uint256[] memory amounts = new uint256[](3);
        uint256 amountOutMin = 0;

        if (usdcAllocationRatio > 0) {
            amounts = uniswapRouter.swapExactTokensForTokens(
                (usdcBalance * usdcAllocationRatio) / 100,
                amountOutMin,
                getPath(address(usdcToken), address(usdtToken)),
                address(this),
                block.timestamp
            );
        }

        if (usdtAllocationRatio > 0) {
            amounts = uniswapRouter.swapExactTokensForTokens(
                (usdcBalance * usdtAllocationRatio) / 100,
                amountOutMin,
                getPath(address(usdcToken), address(daiToken)),
                address(this),
                block.timestamp
            );
        }

        if (daiAllocationRatio > 0) {
            amounts = uniswapRouter.swapExactTokensForTokens(
                (usdcBalance * daiAllocationRatio) / 100,
                amountOutMin,
                getPath(address(usdcToken), address(daiToken)),
                address(this),
                block.timestamp
            );
        }
    }

    // Helper function to get the path for token swapping
    function getPath(
        address fromToken,
        address toToken
    ) private pure returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = fromToken;
        path[1] = toToken;
        return path;
    }
}
