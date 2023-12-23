// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

contract Will {
    address _admin;
    mapping (address => address) _heirs;
    mapping (address => uint) _balances;

    // indexed at owner and heir for search
    event Create(address indexed owner, address indexed heir, uint amount);
    event Deceased(address indexed owner, address indexed heir, uint amount);

    // constructor only called when first deploy
    constructor() {
        _admin = msg.sender;
    }

    function create(address heir) public payable {
        require(msg.value > 0, "Amount must greater than zero");
        require(_balances[msg.sender] <= 0, "Your 'will' already exist");

        _heirs[msg.sender] = heir;
		_balances[msg.sender] = msg.value;

        emit Create(msg.sender, heir, msg.value);
    }

    function deceased(address owner) public {
        require(msg.sender == _admin, "Your don't have permission");
        require(_balances[owner] > 0, "no testament");

        payable(_heirs[owner]).transfer(_balances[owner]);
        // want to clear address from mapping, can set it value to default value, default value of address is 0
        emit Deceased(owner, _heirs[owner], _balances[owner]);
        _heirs[owner] = address(0);
        _balances[owner] = 0;
    }

    function contracts(address owner) public view returns(address heir, uint balance) {
        return (_heirs[owner], _balances[owner]);
    }
}