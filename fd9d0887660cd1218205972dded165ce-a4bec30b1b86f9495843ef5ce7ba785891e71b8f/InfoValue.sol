pragma solidity ^0.4.25;//版本信息

contract InfoFeed{
    uint public gas;
    uint public value;
    address public owner;
    function info() public payable returns(uint ret){
        gas = gasleft();//msg.gas;
        value = msg.value;
        owner = msg.sender;
        return 42;
    }
    function getBalance() public view returns(uint){
        return this.balance;
    }
}
contract Consumer{
    
    InfoFeed feed;
    
    function deposit() public payable{}
    
    function setFeed(address addr) public{
        feed = InfoFeed(addr);
    }
    function callFeed()public payable{
        
        feed.info.value(10).gas(210000)();
    }
}