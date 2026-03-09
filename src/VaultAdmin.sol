// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {VaultStorage} from "./VaultStorage.sol";

contract VaultAdmin is VaultStorage {

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    modifier whenNotPaused() {
        _whenNotPaused();
        _;
    }

    function _onlyOwner() internal view {
        require(msg.sender == owner, "not owner");
    }

    function _whenNotPaused() internal view {
        require(!paused, "paused");
    }

    constructor() {
        owner = msg.sender;
    }

    function setMerkleRoot(bytes32 _root) external onlyOwner {
        merkleRoot = _root;
    }

    function pause() external onlyOwner {
        paused = true;
    }

    function unpause() external onlyOwner {
        paused = false;
    }

    function emergencyWithdrawAll(address to) external onlyOwner {
        payable(to).transfer(address(this).balance);
    }
}
