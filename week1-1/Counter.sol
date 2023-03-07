// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter {
    uint public count;
    function add(uint _number) public {
        count += _number;
    }
}