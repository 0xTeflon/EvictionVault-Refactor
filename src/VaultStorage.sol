// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VaultStorage {

    address public owner;
    bytes32 public merkleRoot;

    bool public paused;

    mapping(address => uint256) public deposits;
    mapping(address => bool) public claimed;

}