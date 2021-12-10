// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;


contract Example {
    uint public seed;

    uint256 counter; // 0, 1,2,3 ...

    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
        uint amount = 0;
        bank[owner] = amount;
    }

    address[] public clients;

    /*
    constructor(uint init_seed) {
        seed = init_seed;
    }
    */
    enum States { Created, Deleted }

    States state;

    uint balance = 0;

    mapping (address => uint) public bank;

    function withdraw() public {
        payable(msg.sender).transfer(balance);
    }

    // 100 000 000 000 = 100

    // 1000000000000000000

    function deposit(uint256 amount) payable public {
        require(msg.value == amount);
        payable(owner).transfer(msg.value);
        bank[owner] = bank[owner] + msg.value;
    }

    function getBalance(address _address) public view returns (uint256) {
        return bank[_address];
    } 
}