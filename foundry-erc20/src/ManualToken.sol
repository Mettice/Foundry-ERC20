// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract ManualToken {
    mapping(address => uint256) private s_balances;

    constructor() {
        s_balances[msg.sender] = totalSupply();
    }

    function name() public pure returns (string memory) {
        return "Manual Token";
    }

    function totalSupply() public pure returns (uint256) {
        return 100 * 10**uint(decimals()); // 100 tokens with 18 decimals
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint256 _value) public {
        require(_to != address(0), "Cannot transfer to the zero address");
        require(s_balances[msg.sender] >= _value, "Insufficient balance");

        uint256 previousBalances = s_balances[msg.sender] + s_balances[_to];
        s_balances[msg.sender] -= _value;
        s_balances[_to] += _value;

        require(s_balances[msg.sender] + s_balances[_to] == previousBalances, "Balance mismatch after transfer");
    }
}
