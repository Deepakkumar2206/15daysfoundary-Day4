// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "forge-std/StdInvariant.sol";
import "../src/MockERC20.sol";
import "../src/TokenSwap.sol";

contract TokenSwapInvariantTest is StdInvariant, Test {
    MockERC20 tokenA;
    MockERC20 tokenB;
    TokenSwap tokenSwap;
    address user = address(0x123);

    function setUp() public {
        tokenA = new MockERC20("TokenA", "TKA");
        tokenB = new MockERC20("TokenB", "TKB");
        tokenSwap = new TokenSwap(address(tokenA), address(tokenB));

        tokenA.mint(address(tokenSwap), 1000 ether);
        tokenB.mint(address(tokenSwap), 1000 ether);

        tokenA.mint(user, 500 ether);
        tokenB.mint(user, 500 ether);

        vm.startPrank(user);
        tokenA.approve(address(tokenSwap), type(uint256).max);
        tokenB.approve(address(tokenSwap), type(uint256).max);
        vm.stopPrank();

        targetContract(address(tokenSwap));
    }

    /// Invariant: Total supply of TokenA should remain constant
    function invariant_totalSupplyA() public {
        assertEq(tokenA.totalSupply(), 1500 ether);
    }

    /// Invariant: Total supply of TokenB should remain constant
    function invariant_totalSupplyB() public {
        assertEq(tokenB.totalSupply(), 1500 ether);
    }
}
