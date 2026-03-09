# EvictionVault Refactor

## Overview

This project refactors the original **EvictionVault monolithic contract** into a modular architecture and implements fixes for several critical security vulnerabilities.

The goal was to improve **security, readability, and maintainability** while keeping the implementation simple and testable within a short development window.

## The system is now structured into multiple contracts with clearly separated responsibilities.

## Project Structure

The original single-file contract was split into modular components:

```
src/
 ├ VaultStorage.sol   // contract storage variables
 ├ VaultAdmin.sol     // admin and emergency controls
 ├ VaultClaim.sol     // user deposit, withdrawal, and claim logic
 ├ EvictionVault.sol  // main vault contract
```

This separation makes the code easier to review, maintain, and extend.

---

## Security Fixes Implemented

### 1. `setMerkleRoot` Access Control

Previously, the Merkle root could be updated by any address.

Fix implemented:

- Function restricted using an `onlyOwner` modifier.
- Only the contract owner can update the Merkle root.

---

### 2. `emergencyWithdrawAll` Public Drain

Previously, any user could call the emergency withdraw function and drain the vault.

Fix implemented:

- Function restricted to the contract owner.
- Prevents unauthorized withdrawal of vault funds.

---

### 3. Pause / Unpause Controls

A pause mechanism was added to allow the contract owner to halt operations during emergencies.

Implemented features:

- `pause()`
- `unpause()`
- `whenNotPaused` modifier applied to user functions.

This allows the protocol to quickly stop deposits or withdrawals if a vulnerability is discovered.

---

### 4. Removed `tx.origin` Usage

The original contract used `tx.origin` for authentication.

This is unsafe because malicious contracts can exploit it.

Fix implemented:

- Replaced all `tx.origin` checks with `msg.sender`.

---

### 5. Replaced `.transfer` with `.call`

The contract originally used `.transfer` for sending ETH.

This is discouraged due to the fixed gas stipend which can break when gas costs change.

Fix implemented:

```
(bool success,) = payable(user).call{value: amount}("");
require(success);
```

This ensures safer and more reliable ETH transfers.

---

### 6. Modular Contract Architecture

The original contract was a **single-file monolith**.

Refactor implemented:

- Separated storage, admin logic, and user interactions into individual contracts.
- Improved readability and easier auditing.

---

## Current Contract State

The refactored system now provides:

- Secure access control for administrative functions
- Emergency pause functionality
- Safe ETH transfer mechanisms
- Removal of unsafe authentication patterns
- A modular and maintainable code structure

The contract compiles successfully using:

```
forge build
```

Basic positive tests confirm that:

- Deposits function correctly
- Withdrawals work as expected
- Pause functionality blocks operations
- Emergency withdrawal is restricted to the owner
- Merkle-based claim logic works

---

## Testing

Tests were written using **Foundry**.

Run the tests with:

```
forge test -vv
```

All positive tests pass successfully.

---

## Conclusion

The EvictionVault contract has been successfully refactored into a modular architecture with critical security vulnerabilities addressed.

Merkle proof verification has also been integrated to ensure that claims are securely validated.

The current implementation focuses on **simplicity, security, and maintainability**, making the contract safer for future development and auditing.
