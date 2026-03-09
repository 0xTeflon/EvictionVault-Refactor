// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {VaultAdmin} from "./VaultAdmin.sol";

contract VaultClaim is VaultAdmin {

    function deposit() external payable whenNotPaused {
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external whenNotPaused {

        require(deposits[msg.sender] >= amount, "not enough");

        deposits[msg.sender] -= amount;

        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "transfer failed");
    }

    function claim() external whenNotPaused {

        require(!claimed[msg.sender], "already claimed");

        uint256 amount = deposits[msg.sender];

        claimed[msg.sender] = true;

        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "transfer failed");
    }

}
