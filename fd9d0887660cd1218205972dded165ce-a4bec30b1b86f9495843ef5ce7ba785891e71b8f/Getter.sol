pragma solidity ^0.4.25;//版本信息

contract Getter{
    enum Color{Blue, Green, Yellow}
    
    struct S{
        uint a;
        string b;
        bytes2 c;
    }
    //基本类型访问器
    uint256 public age = 40;
    
    //枚举访问器
    Color public color = Color.Green;
    
    //数组访问器
    uint [] public array = [1, 2, 3, 4, 5];
    
    //映射访问器
    mapping (uint =>uint) public myMap;
    mapping (address =>uint) public list;
    
    //结构体访问器
    S public s = S(10,"Hello",hex"1234");
    
    
    //结构体访问
    function testStruct() view public returns(uint, bytes2){
        
        var (a, b, c) = this.s();
        //Solidity不支持通过external的访问变长内容,所以不访问string
        return (a, c);
    }
    
    function tsetMap() public returns(uint, uint, uint){
        
        myMap[25] = 100;
        
        list[msg.sender] = 1000;
        
        return(myMap[25], this.myMap(25),list[msg.sender]);
    }
    
    function testArray() public view returns(uint, uint){
        //使用数组访问器访问要用小括号
        return(array[1], this.array(1));
    } 
    
    function testEnum() public view returns(Color,Color){
        
        return(color,this.color());
    }
    
    function testUint() public view returns(uint256,uint256){
        
        return(age,this.age());
    }
}