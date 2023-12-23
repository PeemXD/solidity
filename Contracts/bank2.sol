//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract Bank {

   // _balance variable is a hash table that have key type is address and have value type is uint
    mapping(address => uint) _balance;
    uint _totalSupply;

    // define "payable" for access value in msg (for use msg.value)
    // payable is a modifier
    function deposit() public payable {
        // msg.sender -> get address who call this function
        // msg.value -> get value of coin/token that sender sent
        _balance[msg.sender] += msg.value;
        _totalSupply += msg.value;
    }

    // uint is wei -> 1eth = 10^18 wei
    function withdraw(uint amount) public {
        require(amount <= _balance[msg.sender], "not enough money");

        // transfer to msg.sender need payable 
        // for transfer money from contract to msg.sender
        payable(msg.sender).transfer(amount);
        _balance[msg.sender] -= amount;
        _totalSupply -= amount;
    }

    function checkBalance() public view returns(uint balance) { 
        return _balance[msg.sender];
    }

    function checkTotalSupply() public view returns(uint totalSupply) {
        return _totalSupply;
    }
}