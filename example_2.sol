// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;


contract Example {

    address payable public owner; 


    mapping (address => uint256) addressBook;
   

    constructor() {
        owner = payable(msg.sender);
        addressBook[msg.sender] = 0;        
    }        


    function doSomething() public view {
        require(msg.sender == owner, "You are not allowed to call this function.");


        //  
    }
   
}