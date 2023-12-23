//SPDX-License-Identifier: MIT

// ใช้ภาษา solidity ที่ version 0.8.0 ขึ้นไป
pragma solidity ^0.8.0;

// Class
contract Bank {

    // พี่เขาชอบใช้ _ เพื่อบอกว่าเป็น private
    uint _balance; // Variable in contract(class) by default is private, it give only anyone in contract see

    function deposit(uint amount) public {
        _balance += amount;
    }

    function withdraw(uint amount) public {
        _balance -= amount;
    }

    // if name is duplicate. Normally, end with _. Example balance_
    // in returns have name of parameter because you can see what is you returns in block explorer
    // if the function does not write anything and read some variable. it mean no need to pay for gas.
    // so, insert "view" after accessibility identifier
    // but if the function does not write anything and does not read some variable.
    // you need to insert "pure" after accessibility identifier for remove warning
    // Example,
    function checkBalanceStatic() public pure returns(uint balance) {  // returns function in solidity have "s" for returns multi value or one value
        return 10;
    }

    function checkBalance() public view returns(uint balance) {  // returns function in solidity have "s" for returns multi value or one value
        return _balance;
    }
}