pragma solidity ^0.4.25;

contract A{
    uint public num = 30;
    event LogData(bytes data);
    function() public payable{
        LogData(msg.data);
    }
    function myFunc(uint a) public returns(uint){
        num += a;
        return num;
    }
}
contract B{
    A a;
    function setAddress(address add) public{
        a = A(add);
    }
    function deposit() public payable{}
    function callFunc() public{
        //1.调用失败执行fallback,失败返回false
        a.call("myFunc(uint256)",uint(256));
        //1.调用失败执行fallback,失败返回false
        a.call.value(10)();
        //3.成功
        bytes4 methodId = bytes4(keccak256("myFunc(uint256)"));
        a.call(methodId,1);
        //1.调用失败执行fallback,失败返回false
        a.send(10);
    }
}
