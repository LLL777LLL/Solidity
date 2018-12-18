pragma solidity ^0.4.25;
library Set {
    // 定义了⼀个结构体，保存主调函数的数据（本身并未实际存储的数据）
    struct Data { mapping(uint => bool) flags; }
    // self是⼀个存储类型的引⽤（传⼊的会是⼀个引⽤，⽽不是拷⻉的值），这是库函数的特点。
    // 参数名定为self 也是⼀个惯例，就像调⽤⼀个对象的⽅法⼀样.
    function insert(Data storage self, uint value)public returns (bool){
        if (self.flags[value])
        return false; // 已存在
        self.flags[value] = true;
        return true;
    }
    function remove(Data storage self, uint value)public returns (bool){
        if (!self.flags[value])
        return false;
        self.flags[value] = false;
        return true;
    }
    function contains(Data storage self, uint value)public view returns (bool){
        return self.flags[value];
    }
}
contract C {
    using Set for Set.Data;
    Set.Data knownValues;
    function register(uint value) public {
        // 库函数不需要实例化就可以调⽤，因为实例就是当前的合约
        require(Set.insert(knownValues, value));
    }
    // 在这个合约中，如果需要的话可以直接访问knownValues.flags，
    function getValue(uint value)public view returns(bool){
        return(Set.contains(knownValues,value));
    }
}

library Search {
    function indexOf(uint[] storage self, uint value)public view returns (uint) {
        for (uint i = 0; i < self.length; i++)
        if (self[i] == value) return i;
        return uint(-1);
    }
}
contract UserSearch {
    using Search for uint[];
    uint[] data;
    function append(uint value) public {
        data.push(value);
    }
    function replace(uint _old, uint _new) public {
        // 执行库函数调用
        uint index = data.indexOf(_old);
        if (index == uint(-1))
            data.push(_new);
        else
            data[index] = _new;
    }
}
