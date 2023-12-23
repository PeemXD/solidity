//SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

struct Issue {
    bool open;
    mapping(address => bool) voted;
    mapping(address => uint) ballots; // for user to see own voting results.
    uint[] scores;
    

}

contract Election {
    address _admin;
    mapping(uint => Issue) _issues;
    uint _issueId; // this control present vote
    uint _min;
    uint _max;

    event StatusChange(uint indexed issueId, bool open);
    event Vote(uint indexed  issueId, address voter, uint indexed option);

    constructor(uint min, uint max) {
        _admin = msg.sender;
        _min = min;
        _max = max;
    }

    modifier onlyAdmin {
        require(msg.sender == _admin, "unauthorized");
        // modifier need _;
        _; // next do something...
    }

    function open() public onlyAdmin {
        require(!_issues[_issueId].open, "election opening");

        _issueId++;
        _issues[_issueId].open = true;
        _issues[_issueId].scores = new uint[](_max+1); // if _max = 5, it will allocate memory for new uint[] 6 slot

        emit StatusChange(_issueId, true);

    }

    function close() public onlyAdmin {
        require(_issues[_issueId].open, "election closed");

        _issues[_issueId].open = false;

        emit StatusChange(_issueId, false);
    }

    function vote(uint option) public {
        require(_issues[_issueId].open, "election closed");
        require(!_issues[_issueId].voted[msg.sender], "you are voted");
        require(_min <= option && option <= _max, "incorrect option");

        _issues[_issueId].scores[option]++; // use option(vote that uer choose) as a array index
        _issues[_issueId].voted[msg.sender] = true;
        _issues[_issueId].ballots[msg.sender] = option; 

        emit Vote(_issueId, msg.sender, option);
    }

    // ชื่อชน ใส่ _ ตามหลัง ก็ได้
    function status() public view returns(bool open_) {
        return _issues[_issueId].open;
    }

    function ballot() public view returns(uint option) {
        require(_issues[_issueId].voted[msg.sender], "you haven't voted yet");
        return _issues[_issueId].ballots[msg.sender];
    }

    function scores() public view returns(uint[] memory) {
        return _issues[_issueId].scores;
    }
}