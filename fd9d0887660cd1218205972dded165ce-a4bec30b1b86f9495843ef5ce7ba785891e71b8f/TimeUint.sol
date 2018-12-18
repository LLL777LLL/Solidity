pragma solidity ^0.4.25;//版本信息

contract TimeUint{
    
    function currTimeInSeconds() public view returns(uint256){
        //返回当前时间
        return now;
    }
    function f(uint start, uint minAfter) public view returns(uint){
        
        if(now >= start + minAfter*1 minutes){
            return 1;
        }else{
            return 2;
        }
    }
}