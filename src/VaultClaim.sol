// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
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

    function claim(uint256 amount, bytes32[] calldata proof) external whenNotPaused {

        require(!claimed[msg.sender], "already claimed");

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));

        require(
            MerkleProof.verify(proof, merkleRoot, leaf),
            "invalid proof"
        );

        claimed[msg.sender] = true;

        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "transfer failed");
    }

}
