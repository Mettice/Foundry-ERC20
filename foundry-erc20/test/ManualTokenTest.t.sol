// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ManualToken} from "../src/ManualToken.sol";
import {Test} from "forge-std/Test.sol";

contract ManualTokenTest is Test {
    ManualToken public manualToken;

    address public owner;
    address public recipient;

    uint256 public constant TOTAL_SUPPLY = 100 * 10 ** 18;

    function setUp() public {
        manualToken = new ManualToken();
        owner = address(this);
        recipient = address(0x1);
    }

    function testName() public view {
        assertEq(manualToken.name(), "Manual Token");
    }

    function testTotalSupply() public view {
        assertEq(manualToken.totalSupply(), TOTAL_SUPPLY);
    }

    function testDecimals() public view {
        assertEq(manualToken.decimals(), 18);
    }

    function testBalanceOf() public view {
        assertEq(manualToken.balanceOf(owner), TOTAL_SUPPLY);
    }

    function testTransfer() public {
        uint256 transferAmount = 10 * 10 ** 18;
        manualToken.transfer(recipient, transferAmount);
        assertEq(manualToken.balanceOf(owner), TOTAL_SUPPLY - transferAmount);
        assertEq(manualToken.balanceOf(recipient), transferAmount);
    }

    function testFailTransferInsufficientBalance() public {
        uint256 transferAmount = TOTAL_SUPPLY + 1;
        manualToken.transfer(recipient, transferAmount);
    }

    function testFailTransferToZeroAddress() public {
        uint256 transferAmount = 10 * 10 ** 18;
        manualToken.transfer(address(0), transferAmount);
    }
}
