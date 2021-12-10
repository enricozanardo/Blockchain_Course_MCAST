// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// 10.000.000, 000 000 000 00    1 0 000 000

// 10000000000000000000000000

contract Apple_Token is ERC20 {
    
    constructor() ERC20("Apple", "APL") {
        
        uint256 internalInitialSupply = 73000000000000000000000000;
        
        _mint(msg.sender, internalInitialSupply);
    }
    
    function setMoney(address _userAddress, uint256 _amountApple) public {
        // business logic
        
    }
    
}