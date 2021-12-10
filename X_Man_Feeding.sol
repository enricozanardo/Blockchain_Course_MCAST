// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./X_Man.sol";

contract XManFeeding is XManFactory {
    
    function feedAndMultiply(uint _xManId, uint _targetDna) public {
    require(msg.sender == xMenToOwner[_xManId]);
    
    // XMan storage myXmen = xmen[_xManId];
    
    _targetDna = _targetDna % dnaModulus;
    
    // uint newDna = (myXmen.dna + _targetDna) / 2;
    
    uint newDna = (42 + _targetDna) / 2;
    
    _createXMan("NoName", newDna);
  }
    
    
}