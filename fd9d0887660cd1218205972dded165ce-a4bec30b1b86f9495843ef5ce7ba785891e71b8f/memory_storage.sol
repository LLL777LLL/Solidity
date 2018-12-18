pragma solidity ^0.4.25;//版本信息

contract Memory_Local{
    
    struct S {string a; uint b;}
    //memory赋给 storage
    function memory_local(S s)internal pure{
        //不可以直接赋给storage
        // S temp = s;
        
        //转换为memory类型存储
        S memory temp = s;
    }
    
    //storage赋给storage
    S s1;
    function convertStorage(S storage s1) internal{
        
        S  temp = s1;
        temp.a = "TEST";
    }
    function call() public view returns(string) {
        
        convertStorage(s1);
        
        return s1.a;//TEST
    }
}

//memory赋给状态变量
contract MemoryConvertToStateVariable{
    struct S {string a; uint b;}
    S s;
    
    function memoryToState(S memory temp) internal{
        //从内存中复制到状态变量 
        s = temp;
        //修改 memory中的值,并不会影响到状态变量 
        temp.a = "TEST";
    }
    function call() view returns(string){
        
        S memory temp = S("memory",0);
        
        memoryToState(temp);
        
        //并没有修改为TEST;
        return s.a;//memory
    }

}

//Storage 赋给 Memory
contract StorageToMemory{
    struct S {string a; uint b;}
    
    S s = S("storage",1);
    
    function storagetomemory(S x) internal pure{
        
        //由 storage 拷贝到 memory中
        S memory temp = x;
        
        //memory 修改不会影响 storage
        temp.a = "TEST";
    }
    function call() public view returns(string){
        
        storagetomemory(s);
        
        return s.a;//storage
    }

}

//Memory 赋给 Memory
contract MemorytoMemory{
    struct S {string a; uint b;}
    function memoryToMemory(S s) internal pure{
        
        S memory temp = s;
        
        temp.a = "other memory";
    }
    function call() public view returns(string){
        
        S memory mem = S("memory",1);
        
        //相当于传递 memory 的引用给memoryToMemory,在函数里面修改temp === 修改mem
        memoryToMemory(mem);
        
        return mem.a;
    }
 
}