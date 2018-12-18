pragma solidity ^0.4.25;//版本信息

contract ArrayTest{
    uint [] array;
    
    uint public age = 79;//storage
    
    uint [] public u = [1, 2, 3];//生成访问器
    
    string s = "abcdefg";//storage，属于变长数组
    
    uint [] c; 
    
    function g(){
        uint [] memory m = new uint [] (10);
        //m.length = 20;
        c = new uint [] (7);//可以修改storage数据
        c.length = 10;
        c[9] = 100;
        c.push(200);
        c.push(200);
        c.push(200);
        c.push(200);
    }
    function gl() public view returns(uint){
        return c.length;
    }
    function h() public view returns(uint){
        return bytes(s).length;
    }
    function f() public view returns(byte){
        return bytes(s)[1];//转为数组访问
    }
}

contract C {
    bytes9 a = 0x6c697975656368756e;
    // byte[8] dd = new byte [](8);
    byte[9] aa = [byte(0x6c), 0x69, 0x79, 0x75, 0x65, 0x63, 0x68, 0x75, 0x6e];
    byte [] cc = new byte [](10);
    
    function setAIndex0Byte() public{
        cc.length = 20;
        //错误，不可修改。
        //a[0].0x89;
    }
    function getLength() view returns(uint){
        return cc. length;
    }
    function setAAIndex0Byte() public view returns(byte [9]){
        aa[0] = 0x89;
        return aa;
    }
    function setCC() public view returns(byte []){
        for(uint i = 0; i < a.length; i++){
            cc.push(a[i]);
        }
        return cc;
    }
}