// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract OurTokenTest is StdCheats, Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address public bob;
    address public alice;

    uint256 public constant INITIAL_SUPPLY = 1000 * 10 ** 18;
    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = OurToken(deployer.run());

        bob = address(0x1);
        alice = address(0x2);

        require(INITIAL_SUPPLY >= 2 * STARTING_BALANCE, "Initial supply too low for allocations");

        vm.startPrank(tx.origin);
        ourToken.transfer(bob, STARTING_BALANCE);
        ourToken.transfer(alice, STARTING_BALANCE);
        vm.stopPrank();
    }

    function testInitialSupply() public view {
        assertEq(ourToken.totalSupply(), INITIAL_SUPPLY);
    }

    function testAllowance() public {
        vm.prank(bob);
        ourToken.approve(alice, 50 * 10 ** 18);
        assertEq(ourToken.allowance(bob, alice), 50 * 10 ** 18);
    }

    function testIncreaseAllowance() public {
        uint256 initialAllowance = 50 * 10 ** 18;
        uint256 increaseAmount = 10 * 10 ** 18;
        uint256 expectedAllowance = initialAllowance + increaseAmount;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        vm.prank(bob);
        ourToken.approve(alice, expectedAllowance);
        
        assertEq(ourToken.allowance(bob, alice), expectedAllowance, "Allowance should be increased correctly");
    }

    function testDecreaseAllowance() public {
        uint256 initialAllowance = 50 * 10 ** 18;
        uint256 decreaseAmount = 10 * 10 ** 18;
        uint256 expectedAllowance = initialAllowance - decreaseAmount;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        vm.prank(bob);
        ourToken.approve(alice, expectedAllowance);

        assertEq(ourToken.allowance(bob, alice), expectedAllowance, "Allowance should be decreased correctly");
    }

    function testTransfer() public {
        uint256 transferAmount = 10 * 10 ** 18;
        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ourToken.balanceOf(alice), STARTING_BALANCE + transferAmount);
    }

    function testTransferFrom() public {
        uint256 transferAmount = 10 * 10 ** 18;
        vm.prank(bob);
        ourToken.approve(alice, transferAmount);
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ourToken.balanceOf(alice), STARTING_BALANCE + transferAmount);
        assertEq(ourToken.allowance(bob, alice), 0);
    }

    function testFailTransferInsufficientBalance() public {
        uint256 transferAmount = STARTING_BALANCE + 1;
        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);
    }

    function testFailTransferFromInsufficientAllowance() public {
        uint256 transferAmount = 10 * 10 ** 18;
        vm.prank(bob);
        ourToken.approve(alice, transferAmount - 1);
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
    }

    function testBurnTokens() public {
        uint256 burnAmount = 10 * 10 ** 18;
        vm.prank(bob);
        ourToken.burn(burnAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - burnAmount);
        assertEq(ourToken.totalSupply(), INITIAL_SUPPLY - burnAmount);
    }

    function testFailBurnMoreThanBalance() public {
        uint256 burnAmount = STARTING_BALANCE + 1;
        vm.prank(bob);
        ourToken.burn(burnAmount);
    }

    function testFailApproveZeroAddress() public {
        vm.prank(bob);
        ourToken.approve(address(0), 50 * 10 ** 18);
    }

    function testFailTransferToZeroAddress() public {
        uint256 transferAmount = 10 * 10 ** 18;
        vm.prank(bob);
        ourToken.transfer(address(0), transferAmount);
    }

    function testApproveAndCall() public {
        uint256 approveAmount = 50 * 10 ** 18;
        vm.prank(bob);
        ourToken.approve(alice, approveAmount);
        assertEq(ourToken.allowance(bob, alice), approveAmount);
        vm.prank(alice);
        bool success = ourToken.transferFrom(bob, alice, approveAmount);
        assert(success);
        assertEq(ourToken.balanceOf(alice), STARTING_BALANCE + approveAmount);
    }

    // Additional Tests
    function testMintToAccount() public {
        uint256 mintAmount = 50 * 10 ** 18;
        address recipient = address(0x3);

        // Mint new tokens
        vm.prank(ourToken.owner());
        ourToken.mint(recipient, mintAmount);

        // Assert new balance and total supply
        assertEq(ourToken.balanceOf(recipient), mintAmount);
        assertEq(ourToken.totalSupply(), INITIAL_SUPPLY + mintAmount);
    }

    function testFailMintToZeroAddress() public {
        uint256 mintAmount = 50 * 10 ** 18;

        // Attempt to mint to zero address
        vm.prank(ourToken.owner());
        ourToken.mint(address(0), mintAmount);
    }
}
