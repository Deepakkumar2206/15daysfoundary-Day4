# Token Swap Testing with Foundry


## This project demonstrates **ERC20 token swapping** using Solidity and advanced **Foundry testing techniques**:
- Fuzzing (randomized inputs)
- Bounded fuzzing (restricted randomized inputs)
- Invariant testing (properties that must always hold true)


## Prerequisites

Before running this project, make sure you have:


**Foundry installed**
   
```shell
$ curl -L https://foundry.paradigm.xyz | bash
   
$ foundryup
```


## OpenZeppelin Contracts (used for ERC20 token implementation)

```shell
$ forge install OpenZeppelin/openzeppelin-contracts
```

## Why OpenZeppelin?

Provides battle-tested smart contract templates.

Reduces chances of security vulnerabilities.

Saves time instead of rewriting standard ERC20 logic.

## Contract Files

### 1. MockERC20.sol
A minimal ERC20 token using OpenZeppelin's ERC20.

Has a mint function to create tokens for testing.

Used for simulating Token A and Token B in tests.

### 2. TokenSwap.sol
Contract that allows swapping Token A for Token B and vice versa.

Uses transferFrom to take tokens from user, and transfer to send back swapped tokens.

Assumes 1:1 swap rate for simplicity.

## Test Files
### 1. TokenSwap.t.sol (Fuzz Testing)
Uses Foundry's fuzzing to send random amounts to swapAToB and swapBToA.

Ensures swaps work for many possible inputs.

### 2. TokenSwapBounded.t.sol (Bounded Fuzz Testing)
Like fuzz testing, but restricts random input range using bound() function.

Prevents out-of-range swaps that would fail.

### 3. TokenSwapInvariant.t.sol (Invariant Testing)
Checks that total supply of Token A and Token B never changes, no matter how swaps occur.

Runs hundreds of random actions automatically.


## Running the Project

### Compile Contracts

```shell
$ forge build
```

### Run All Tests

```shell
$ forge test -vvvv
```

## Sample Output & Explanation

```shell
Ran 2 tests for test/TokenSwap.t.sol:TokenSwapTest
[PASS] testFuzz_swapAToB(uint256) (runs: 258, μ: 67888, ~: 67170)
[PASS] testFuzz_swapBToA(uint256) (runs: 258, μ: 67729, ~: 67148)

Ran 2 tests for test/TokenSwapBounded.t.sol:TokenSwapBoundedTest
[PASS] testFuzz_swapAToB(uint256) (runs: 258, μ: 67750, ~: 67148)
[PASS] testFuzz_swapBToA(uint256) (runs: 258, μ: 67822, ~: 67199)

Ran 2 tests for test/TokenSwapInvariant.t.sol:TokenSwapInvariantTest
[PASS] invariant_totalSupplyA() (runs: 256, calls: 128000, reverts: 127979)
[PASS] invariant_totalSupplyB() (runs: 256, calls: 128000, reverts: 127973)
```
## What this means:
### testFuzz_swapAToB / testFuzz_swapBToA
- These are fuzz tests.
- (runs: 258) → Foundry tried 258 random swap amounts.
- μ and ~ show average and median gas usage.
- All runs passed.

### Bounded Fuzz Tests
- Same as fuzz tests, but swap amounts are limited to the user’s balance.
- Prevents invalid amounts like swapping more than available.

### Invariant Tests
- (runs: 256) → Foundry ran 256 random sequences of actions.
- (calls: 128000) → Total number of function calls tested.
- reverts means some calls reverted (expected in invalid scenarios).
- The key point: The total supply of Token A and B never changed, proving the contract maintains supply invariants.

## End of the Project.  



