// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract XManFactory {
    
    uint256 dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    
    event NewXMan(uint xManId, string name, uint dna);
    
    struct XMan {
        string name;
        uint dna;
    }
    
    XMan[] public xmen;
    
    mapping (uint => address) public xMenToOwner;
    mapping (address => uint) ownerXManCount;
    
    function _createXMan(string memory _name, uint _dna) internal {
        xmen.push(XMan(_name, _dna));
        uint256 id = xmen.length;
        
        xMenToOwner[id] = msg.sender;
        ownerXManCount[msg.sender]++;
        
        emit NewXMan(id, _name, _dna);
    }
    
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }
    
    function createRandomXMan(string memory _name) public {
        require(ownerXManCount[msg.sender] == 0);
        
        uint randDna = _generateRandomDna(_name);
        _createXMan(_name, randDna);
    }

    
}