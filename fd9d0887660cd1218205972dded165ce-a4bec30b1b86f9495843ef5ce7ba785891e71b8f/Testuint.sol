pragma solidity ^0.4.25;//版本信息
contract C {
    function f() public pure{
        g([uint8(1),2,3]);
    }
    function g(uint8[3] _data) public pure{
        //...
    }
}