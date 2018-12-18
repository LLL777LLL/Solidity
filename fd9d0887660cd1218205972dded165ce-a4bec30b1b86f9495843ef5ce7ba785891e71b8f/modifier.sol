pragma solidity ^0.4.25;//版本信息

contract Ownable{
    address public owner = msg.sender;
    //限制只有创建者才可以访问
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    //改变合约的所有者
    function changeOwner(address _newOwener) public onlyOwner{
        
        require(_newOwener != 0x0);
        owner = _newOwener;
    }
}

contract Parameter{
    uint balance = 10;
    
    modifier lowerLimit(uint _balance, uint _withdraw){
        require(_withdraw >= 0 && _withdraw <= _balance);
        _;
    }
    //带参数的函数修饰器 
    function f(uint withdraw) lowerLimit(balance, withdraw) public view returns(uint){
        return balance;
    }
}

contract Return{
    //当修饰器没有执行成功时,函数会返回对应类型的默认值
    modifier A(){
        if(false){
            _;
        }
    }
    function uintReturn() A pure public returns(uint){
        
        uint a = 10;
        return a; 
    }
    
    function stringReturn() A pure public returns(string){
        
        return "你好";
    }
}

contract ProcessFlow{
    mapping(bool => uint) public mapp;
    
    modifier A(mapping(bool => uint) _mapp){
        if(mapp[true] == 0){
            mapp[true] = 1;
            // return;//终端当前执行
            mapp[true] = 3;
            _;
        }
    }
    function f() A(mapp) public returns(uint){
        mapp[true] = 2;
        return mapp[true];//这个return会在程序执行完之后执行。
    }
}

contract MultiModifier{
    address owner = msg.sender;
    
    //限制只有创建者才能访问
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    modifier inState(bool state){
        require(state);
        _;
    }
    function f(bool state) onlyOwner inState(state) public view returns(uint){
        return 1;
    }
}

//父类
contract bank{
    modifier transferLimit(uint _withdraw){
        require(_withdraw <= 100);
        _;
    }
}

//继承自父类bank
contract ModidierOverride is bank{
    //重写父类的方法
    modifier transferLimit (uint _withdraw){
       require(_withdraw <= 10);
        _; 
    }
    function f(uint withdraw) transferLimit(withdraw) public pure returns(uint){
        return withdraw;
    }
}

//modifier的嵌套
contract modifierSample{
    
    uint a = 10;
    // fixed constant e = 3.14;
    modifier mf1(uint b){
        uint c = b;
        _;
        c = a;
        a = 11;
    }
    modifier mf2(){
        uint c = a;
        _;
    }
    modifier mf3(){
        a = 12;
        return;//return 只对mf3有影响。
        _;
        a =13;
    }
    //modifier嵌套时从后往前推。
    function test1() mf1(a) mf2 mf3 public {
        a =1;
    }
    function test2() public view returns(uint){
        return a;
    }
}