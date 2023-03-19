// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IScore {
    function setScore(address student, uint score) external;
    function getScore(address student) external view returns (uint);
}

contract Score is IScore {
    address public teacher;
    mapping(address => uint) public scores;

    constructor() {
        teacher = msg.sender;
    }

    modifier onlyTeacher() {
        require(msg.sender == teacher, "Not teacher");
        _;
    }

    function setScore(address _student, uint _score) public onlyTeacher {
        require(_score <= 100, "Score can't be than 100");
        scores[_student] = _score;
    }

    function getScore(address _student) public view override returns (uint) {
        return scores[_student];
    }
}

// Teacher合约
contract Teacher {
    IScore public scoreContract;
    constructor(address _scoreAddress) {
        scoreContract = IScore(_scoreAddress);
    }

    function setScore(address _student, uint _score) public {
        scoreContract.setScore(_student, _score);
    }

    function getScore(address _student) public view returns (uint) {
        return scoreContract.getScore(_student);
    }
}

