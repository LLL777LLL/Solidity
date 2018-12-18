pragma solidity ^0.4.25;
contract SimpleStorage {
    uint storedData;
    function set(uint x) public {
        storedData = x;
    }
    function get() public constant returns (uint) {
        return storedData;
    }
    function abiEncode() public pure returns(bytes, bytes){
        abi.encode(1);//利用keccak算法计算ABI编码。
        //计算函数set（uint256)
        return (abi.encode(1), abi.encodeWithSignature("set(uint256)",1));
    }
    function test() public pure returns(bool){
        if(bytes4(keccak256("set(uint256)")) == 0x60fe47b1){
            return true;
        }
        return false;
    }
    
}

contract DleteEnum{
    enum Light{RED, GREEN, YELLOW}
    Light light;
    function f()public returns(Light){
        light = Light.GREEN;
        delete light;
        return light;
    }
}

contract DeleteStruct{
    struct S{
        uint a;
        string b;
        bytes c;
    }
    S s;
    function delStruct()public view returns (uint, string, bytes){
        s = S(10, "Hello world!", "abc");
        delete s;
        return (s.a, s.b, s.c);
    }
}
contract DeleteDynamicArr{
    function delDynamicArr() view returns(uint){
        uint[] memory a = new uint[](7);
        uint[] memory b = new uint[](7);
        b = a;
        a[0] = 100;
        a[1] = 200;
        
        delete a;
        
        return(b[0]);
    }
    
}

contract DeleteStorageRef{
    struct S{}
    S s;
    constructor(){
        s = S();
        S memory s1 = S();
        S storageRef = s;
        //不能直接删除指向s的storageRef
        // delete storageRef;
        
        delete s;
        
    }
}