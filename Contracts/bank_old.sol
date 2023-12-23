//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol -> delete "https://" and "blob/master"
import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/Math.sol";

// Class
contract Bank {
    using Math for uint; // make extention method for uint from external library (import) but 0.8.x is not necessary

    uint _balance;

    function deposit(uint amount) public {
        _balance += amount;
    }

    function withdraw(uint amount) public {
        // require(amount <= _balance, "balance is not enought"); // version 0.7.x need this for prevent error but 0.8.x don't need
        // _balance = _balance.sub(amount); // use sub from Math (external library)
        // present, method sub removed
    }

    function checkBalance() public view returns(uint balance) {  
        return _balance;
    }
}