// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract payableSample {

    address payable public Owner;
    
    mapping(address => uint) public clients;


    constructor() {
        Owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == Owner, "Not Owner");
        _;
    } 

    function withdraw(uint _amount) public onlyOwner {
        Owner.transfer(_amount);
    }

    function checkBalance() public view {
        Owner.balance;
    }

    function transfer(address payable _to, uint _amount) public {
        _to.transfer(_amount);
    }

    function payMeMoney() public payable {
        // Owner.transfer(msg.value);

        clients[msg.sender] = msg.value;
    }

}