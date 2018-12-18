pragma solidity ^0.4.25;//版本信息
import "./StructTest.sol";
contract Complex {
    struct Data {
        uint a;
        bytes3 b;
        mapping (uint => uint) map;
    }
    mapping (uint => mapping(bool => Data[])) public data;
    
    Data[] internal arr;
    
    function f() public returns (uint, bytes3){
        Data memory d = Data(1, 0x123);
        arr.push(d);
        data[0][true] = arr;
        
        //去访问map对应下标0的键true的值arr数组对应的下标0的值 
        return this.data(0, true, 0);
    }
}