pragma solidity ^0.4.25;
contract ExecuteFallback{
    uint a;
    constructor() public payable {}
    
    //回退事件，会把调⽤的数据打印出来
    event FallbackCalled(bytes data);
    
    //fallback函数，注意是没有名字的，没有参数，没有返回值的
    function() public payable{
        emit FallbackCalled(msg.data);
        //只能在fallback函数中进行一些日志操作，其他操作会导致失败
        //注：send()方式的有2300gas的限制
        // a =1;
        
    }
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    //调⽤已存在函数的事件，会把调⽤的原始数据，请求参数打印出来
    event ExistFuncCalled(bytes data, uint256 para);
    //⼀个存在的函数
    function existFunc(uint256 para)public payable{
        emit ExistFuncCalled(msg.data, para);
    }
    
    // 模拟从外部对⼀个存在的函数发起⼀个调⽤，将直接调⽤函数
    function callExistFunc()public returns(bool){
        bytes4 funcIdentifier = bytes4(keccak256("existFunc(uint256)"));
        // address(this).call();
        return address(this).call.value(10)(funcIdentifier, uint256(1));
    }
    
    //模拟从外部对⼀个不存在的函数发起⼀个调⽤，由于匹配不到函数，将调⽤回退函数
    function callNonExistFunc()public returns(bool){
        bytes4 funcIdentifier = bytes4(keccak256("functionNotExist()"));
        return address(this).call(funcIdentifier);
    }
    event SendEventr(address to, uint value, bool result);
    //使用sender()发送ether,观察会触发fallback函数,不要添加view，view修饰会发送失败。
    function sendEther()public returns(bool){
        bool result = address(this).send(1);
        emit SendEventr(this, 1, result);
        return result;
    }
}