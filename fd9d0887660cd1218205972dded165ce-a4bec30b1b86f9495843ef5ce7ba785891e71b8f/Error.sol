pragma solidity ^0.4.25;//版本信息

contract Error{
    uint a= 30;
    function deposit() public payable {}
    
    function kill(address add) public{
        selfdestruct(add);
    }
    //用于判断输入或外部组件错误，条件不满足时抛出异常
    function testRequire() public view returns(uint){
        require(a == 30);
        return a;
    }
    //用于判断内部错误，条件不满足时抛出异常
    function testAssert() public view returns(uint){
        assert(a == 30);
        return a;
    }
    function testRevert() public pure returns(uint){
        revert();
    }
}