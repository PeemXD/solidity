//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Bank {
    mapping(address => uint) _balances;

    // event use for subscribe to see all event that occur (monitor event)
    // event similar log
    // indexed use for filter to see. Example, address indexed owner for filter see only this address
    event Deposit(address indexed owner, uint amount);
    event Withdraw(address indexed owner, uint amount);

    function deposit() public payable {
        require(msg.value > 0, "depost money is zero");

        _balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint amount) public {
        require(amount > 0 && amount <= _balances[msg.sender], "not enough money");

        payable(msg.sender).transfer(amount);
        _balances[msg.sender] -= amount;
        // emit event similar write log
        emit Withdraw(msg.sender, amount);
    }

    function balance() public view returns(uint Balance) {
        return _balances[msg.sender];
    }

    function balanceOf(address owner) public view returns(uint Balance) {
        return _balances[owner];
    }
}