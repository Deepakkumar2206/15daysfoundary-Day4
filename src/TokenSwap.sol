// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSwap {
    IERC20 public tokenA;
    IERC20 public tokenB;

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function swapAToB(uint256 amount) public {
        require(amount > 0, "Amount must be > 0");
        require(tokenB.balanceOf(address(this)) >= amount, "Not enough TokenB in pool");

        require(tokenA.transferFrom(msg.sender, address(this), amount), "TokenA transfer failed");
        require(tokenB.transfer(msg.sender, amount), "TokenB transfer failed");
    }

    function swapBToA(uint256 amount) public {
        require(amount > 0, "Amount must be > 0");
        require(tokenA.balanceOf(address(this)) >= amount, "Not enough TokenA in pool");

        require(tokenB.transferFrom(msg.sender, address(this), amount), "TokenB transfer failed");
        require(tokenA.transfer(msg.sender, amount), "TokenA transfer failed");
    }
}
