//SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// folder name inf is a token name

// internal mean can use in this contract and child that inherit this contract
// external mean only call from outside the contract 
// standard for ERC20 can change name of varable. Example change "value" to "amount"
interface IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256 balance);
    function transfer(address to, uint256 amount) external returns (bool success);
    function approve(address spender, uint256 amount) external returns (bool success);
    function allowance(address owner, address spender) external view returns (uint256 remaining);
    function transferFrom(address from, address to, uint256 amount) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
}
// private modifier can not use in abstract contract(class)
// mean if child extend this contract, child cannot call private function
// you must use internal for another that extend you contract can use that function
// abstract cannot deploy
abstract contract ERC20 is IERC20 {
    // global variable in contract is a storage(store in blockchain)
    string _name;
    string _symbol;
    // uint is alias of uint256
    uint _totalSupply;
    mapping(address => uint) _balances;
    mapping(address => mapping(address => uint)) _allowances; // owner => (spender => amount)

    // solidity มันแยกชื่อ function กับ variable ไม่ออก ดังนั้นชื่อ variable ด้านล่างจึงใช้ name_ แทนที่จะเป็น name แล้วมันจะซ้ำกับชื่อ function name()
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    // change external to public
    function name() public override view returns (string memory) {
        return _name;
    }

    function symbol() public override view returns (string memory) {
        return _symbol;
    }

    function decimals() public override pure returns (uint8) {
        // return 18; // normal reference from ether to wei(10**18)
        // but in this contract we use 0 because it easy and change "view" to "pure"
        return 0;
    }

    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public override view returns (uint256 balance) {
        return _balances[owner];
    }

    function transfer(address to, uint256 amount) public override returns (bool success) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    // approve for ฝากคนอื่นเอาเหรียญเราไปส่งให้อีกคน
    function approve(address spender, uint256 amount) public override returns (bool success) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) public override view returns (uint256 remaining) {
        return _allowances[owner][spender];
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool success) {
        if (from != msg.sender) {
            uint allowanceAmount = _allowances[from][msg.sender];
            require(amount <= allowanceAmount, "transfer amount exceeds allowance");
            _approve(from, msg.sender, allowanceAmount - amount);
        }

        _transfer(from, to, amount);
        return true;
    }

    //== Private Function ======
    function _transfer(address from, address to, uint amount) internal {
        require(from != address(0), "miss you address");
        require(to != address(0), "need address for transfer");
        require(amount <= _balances[from], "trasfer amount exceeds balance");  // จริงๆ version 0.8.x ดักให้แล้ว แต่ดักไง้ก็ดี

        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _approve(address owner, address spender, uint amount) internal {
        require(owner != address(0), "miss owner address");
        require(spender != address(0), "miss spender address");
        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);
    }

    function _mint(address to, uint amount) internal {
        require(to != address(0), "Can not mint to zero address");
        _balances[to] += amount; 
        _totalSupply += amount;

        // Normally, mint token from address(0)
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint amount) internal {
        require(from != address(0), "Cannot burn from zero address");
        require(amount <= _balances[from], "burn amount exceeds balance");

        _balances[from] -= amount;
        _totalSupply -= amount;

        emit Transfer(from, address(0), amount);
    }
}

// deploy this
contract MNC is ERC20 {
    // call mom constructor
    constructor() ERC20("Mini Coin", "MNC") {

    }

    function deposit() public payable {
        require(msg.value > 0, "amount is zero");

        _mint(msg.sender, msg.value);
    }

    function withdraw(uint amount) public {
        require(amount > 0 && amount <= _balances[msg.sender], "withdraw amount exceeds balance");
        payable(msg.sender).transfer(amount);
        _burn(msg.sender, amount);
    }
}