// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {VaultClaim} from "./VaultClaim.sol";

contract EvictionVault is VaultClaim {

    receive() external payable {
        deposits[msg.sender] += msg.value;
    }

}
