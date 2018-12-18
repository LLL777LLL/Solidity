pragma solidity ^0.4.25;//版本信息

contract MapTest{
    
    mapping(uint => string) myMap;
    
    function setMap(uint index ,string value)public{
        // mapping(uint => string) m;
        myMap[index] = value;
    }
    function getMap(uint index) public view returns(string){
        return myMap[index];
    }
}