pragma solidity ^0.4.25;
contract Person{
    uint age = 30;
    function somePublicFunc() public pure{}
    function sonmPrivateFunc() private pure{}
    function sonmInternalFunc() internal pure{}
    function sonmExterbalFunc() external pure{}
}
contract Manager is Person{
    
    
    function f() public view returns(uint){
        
        somePublicFunc();
        
        this.sonmExterbalFunc();
        
        //不能在子类里面访问
        // sonmPrivateFunc();
        
        sonmInternalFunc();
        
        return age;
    }
    
}
contract Base{
    string s;
    uint a;
        event Base(string);
    constructor() public{
        // a = _a;
        // s = _s;
        Base("Base");
    }
}
//调用父类的构造函数给a赋值1
contract Derived is Base{
    //继承,初始化列表
    constructor() public {}
    
    function getBasePara() public view returns(uint, string){
        return (a, s);
    }
}