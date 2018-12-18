pragma solidity ^0.4.25;//版本信息

contract InfoContract{
    
    event Instructor(string name, uint age);
    string fName;
    uint age;
    uint public value;
    address public addr;
    function deposit() public payable{
        value = msg.value;
        addr = msg.sender;
    }
    function setInfo(string _fName, uint _age) public{
        fName = _fName;
        age = _age;
        Instructor(fName, age);
    }
}