// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address public owner;
    mapping(address => uint) public deposits;
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    // 将接收到的eth存入对应账户
    receive() external payable {
        deposits[msg.sender] += msg.value;
    }
    // 获取调用者账户的余额
    function myDeposited() public view returns(uint) {
        return deposits[msg.sender];
    }

    // 用户取出部分eth
    function withdrawSome(uint256 _amount) public{
        require(_amount < 0,"amount not < 0");
        require(_amount > deposits[msg.sender],"not than balance");
        (bool success, ) = msg.sender.call{value: _amount}(new bytes(0));
        require(success, 'ETH transfer failed');
        deposits[msg.sender] -= _amount;

    }
    // 用户取出自己全部的余额
    function withdraw() public {
        (bool success, ) = msg.sender.call{value: deposits[msg.sender]}(new bytes(0));
        require(success, 'ETH transfer failed');
        deposits[msg.sender] = 0;
    }

    // 将所有eth转给合约部署者
    function  withdrawAll() public onlyOwner {
        uint b = address(this).balance;
        payable(owner).transfer(b);
    }

}