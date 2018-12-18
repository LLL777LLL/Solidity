pragma solidity ^0.4.25;
contract Base1{
    string s = "张三";
    uint a = 20;
    constructor(uint _a,string _s) public{
        a = _a;
        s = _s;
    }
    function cc()public pure{}
}
contract Base2{
    string s = "李四";
    uint a =30;
    constructor(uint _a,string _s) public{
        a = _a;
        s = _s;
    }
    function cc()public pure{}

}
//调用父类的构造函数给a赋值1
contract Derived is Base2,Base1{
    //继承,初始化列表
    constructor(uint _a, string _s) Base1(_a, _s) public {}
    
    function getBasePara() public view returns(uint, string){
        return (a, s);
    }
}

contract Base{
    function data()public pure  returns(uint){
        return 1;
    }
}
contract InheritOverride is Base{
    function data(uint) public pure {}
    
    function data()public pure returns(uint){}
    
    //Override changes extended function signature
    //function data() returns(string){}
}
contract owned {
    constructor() public { owner = msg.sender; }
        address owner;
    }
contract mortal is owned {
    event mortalCalled(string);
    
    function kill() public {
        mortalCalled("mortalCalled");
        if (msg.sender == owner) selfdestruct(owner);
    }
}
/*
在SpecifyBase我们打算完成一些特有的清理流程，但想复用父合约的清理流程，
可以通过mortal.kill()的方式直接调用父合约的函数。
*/
contract SpecifyBase is mortal {
    event SpecifyBase(string);
    function kill() public {
        SpecifyBase("do own cleanup");
        mortal.kill();
    }
}

contract ownedTest {
    constructor() public { owner = msg.sender; }
    address owner;
}
contract mortalTest is ownedTest {
    event mortalTestCalled(string);
    function kill() public {
        mortalTestCalled("mortalTestCalled");
        //销毁自身
        if (msg.sender == owner) selfdestruct(owner);
    }
}
contract Base1Test is mortalTest {
    event Base1TestCalled(string);
    function kill() public {
        /* do cleanup 1 */
        Base1TestCalled("Base1TestCalled");
        super.kill();
    }
}
contract Base2Test is mortalTest {
    event Base2TestCalled(string);
    function kill() public {
        /* do cleanup 2 */
        Base2TestCalled("Base2TestCalled");
        super.kill();
    }
}
/*
    如果 Base2 调用 super 的函数，它不会简单在其基类合约上调用该函数。
相反，它在最终的继承关系图谱的下一个基类合约中调用这个函数，所以
它会调用 Base1.kill() （注意最终的继承序列是——从最远派生合约开始：Final,
Base2, Base1, mortal, ownerd）。 在类中使用 super 调用的实际函数在当前类
的上下文中是未知的，尽管它的类型是已知的。 这与普通的虚拟方法查找类似。
*/
contract FinalWithSuper is Base1Test, Base2Test {
}