pragma solidity ^0.4.25;

contract Feline{
    uint a = 20;
    function utterance() public returns(bytes32);
}

contract Cat is Feline{
    function utterance() public returns(bytes32){
        return "黄哲";
    }
}
interface Token{
    event MyEvent();
    function transfer(address recipient, uint amount) external;
}
contract MyCoin is Token{
    function transfer(address recipient, uint amount)public{
        recipient.send(amount);
    }
}