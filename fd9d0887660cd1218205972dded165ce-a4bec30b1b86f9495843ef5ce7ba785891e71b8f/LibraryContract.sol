pragma solidity ^0.4.25;

library libraryTest{
    function relatedVar()external view returns(address, address, uint) {
        
        return(this, msg.sender, msg.value);
    }
}

contract Contract{
    
    function calling()public view returns(address, address, address, address, uint, uint){
        
        var(libAddr, libSender, libVal) = libraryTest.relatedVar();
        var(contractAddr, contractSender, contractVal) = (this, msg.sender, msg.value);
        return(libAddr, contractAddr, libSender, contractSender, contractVal, libVal);
    }
}
library Utils{
    function toUint(uint a)public pure returns(uint){
        return a;
    }
    function toUint()public pure returns(uint){
        return 0;
    }
    function toByte32(bytes32 b)public pure returns(bytes32){
        return b;
    }
}
contract libraryUsingForAny{
    //可以附加到任意的类型
    using Utils for *;
    function call()public pure returns(uint, bytes32){
        
        uint i = 10;
        bytes32 b = "abc";
        
        return(i.toUint(), b.toByte32());
    }
}