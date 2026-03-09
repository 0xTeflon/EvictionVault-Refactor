// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {EvictionVault} from "../src/EvictionVault.sol";

contract EvictionVaultTest is Test {

    EvictionVault vault;

    function setUp() public {
        vault = new EvictionVault();
    }

    receive() external payable {}

    // deposit works
    function testDeposit() public {

        vault.deposit{value: 1 ether}();

        assertEq(vault.deposits(address(this)), 1 ether);
    }


    // withdraw works
    function testWithdraw() public {

        vault.deposit{value: 1 ether}();

        vault.withdraw(1 ether);

        assertEq(vault.deposits(address(this)), 0);
    }

    // pause blocks actions
        function testPause() public {

        vault.pause();

        vm.expectRevert();

        vault.deposit{value: 1 ether}();
    }

    // emergency withdraw works
    function testEmergencyWithdraw() public {

        vault.deposit{value: 1 ether}();

        vault.emergencyWithdrawAll(address(this));

        assertEq(address(vault).balance, 0);
    }

}

