// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/TokenSwap.sol";
import "../src/MockERC20.sol";

contract TokenSwapTest is Test {
    TokenSwap public tokenSwap;
    MockERC20 public tokenA;
    MockERC20 public tokenB;
    address public user;

    function setUp() public {
        tokenA = new MockERC20("TokenA", "TKA");
        tokenB = new MockERC20("TokenB", "TKB");

        tokenSwap = new TokenSwap(address(tokenA), address(tokenB));

        tokenA.mint(address(tokenSwap), 1000 ether);
        tokenB.mint(address(tokenSwap), 1000 ether);

        user = address(0x123);

        tokenA.mint(user, 500 ether);
        tokenB.mint(user, 500 ether);

        vm.startPrank(user);
        tokenA.approve(address(tokenSwap), type(uint256).max);
        tokenB.approve(address(tokenSwap), type(uint256).max);
        vm.stopPrank();
    }

    function testFuzz_swapAToB(uint256 amount) public {
        amount = bound(amount, 1, tokenA.balanceOf(user));

        uint256 balanceBefore = tokenB.balanceOf(user);

        vm.startPrank(user);
        tokenSwap.swapAToB(amount);
        vm.stopPrank();

        assertEq(tokenB.balanceOf(user) - balanceBefore, amount);
    }

    function testFuzz_swapBToA(uint256 amount) public {
        amount = bound(amount, 1, tokenB.balanceOf(user));

        uint256 balanceBefore = tokenA.balanceOf(user);

        vm.startPrank(user);
        tokenSwap.swapBToA(amount);
        vm.stopPrank();

        assertEq(tokenA.balanceOf(user) - balanceBefore, amount);
    }
}
