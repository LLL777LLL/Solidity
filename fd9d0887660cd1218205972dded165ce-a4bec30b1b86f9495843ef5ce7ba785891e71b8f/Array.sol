pragma solidity ^0.4.25;//版本信息

contract Array{
    
    //定长数组,数组长度为5，定长数组不能修改长度
    uint [5] T1 = [1, 2, 3, 4, 5];
    
    //不定长数组可以push添加成员 
    uint [] T2 = [1, 2, 3, 4, 5];
    
    //通过for循环求T1总和
    function sum() constant public returns(uint){
        uint num = 0;
        for(uint i = 0; i < T1.length; i++){
            num = num + T1[i];
        }
        return num;
    }
    //给数组T2添加成员 
    function pushT2() public returns(uint []){
        T2.push(6);
        T2.push(7);
        T2.push(8);
        return T2;
    }
}