pragma solidity ^0.4.25;//版本信息

contract MappingExample{
    mapping(address => uint ) public balances;
    
    function update(uint newBalance) public{
        balances[msg.sender] = newBalance;
    }
    function testSender() public view returns(address){
        return msg.sender;
    }
}
contract MappingUser{
    MappingExample m = new MappingExample();

    function f() public view returns(uint){
        m. update(100);
        return m.balances(this);
    }
    function getTestSender() public view returns(address){
        
        // MappingExample m = new MappingExample();
        
        address local = m.testSender();
        return local;

    }
}