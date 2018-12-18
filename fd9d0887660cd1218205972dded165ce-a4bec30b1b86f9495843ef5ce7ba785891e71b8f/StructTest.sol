pragma solidity ^0.4.25;//版本信息

contract StructTest{
    struct Person{
        string name;
        uint age;
        Add road;
    }
    //结构体包含的结构体
    struct Add{
        string road;
    }
    
    Person p;
    Person [] pArr;//结构体数组 
    function AddPerson() public{
        //暂时不支持复制结构体 
        // pArr = new Person[](10);
        Add memory add = Add("北京");
        
        Person memory p1 = Person("李四",30,add);
        //也可以使用键值的方式赋值
        Person memory p2 = Person({age:60,name:"王五",road:add});
        //结构体数组可以使用push方法 
        pArr.push(p2);
        pArr.push(p1);
        pArr.push(p1);
        pArr.push(p1);
        pArr.push(p1);
        pArr.push(p1);

    }
    
    function sumAge()public view returns(uint){
        uint sum;
        for(uint i = 0; i < pArr.length; i++){
            sum = sum+pArr[i].age;
        }
        return sum;
    }
    
    function getName() public view returns(string){
        return p.name;
    }
    function getAge() public view returns(uint){
        return p.age;
    }
    
    function getRoad() public view returns(string){
        return p.road.road;
    }
    function f() public{
        //先初始化被包含的结构体
        Add memory add = Add("北京");
        //初始化
        p = Person("张三",20,add);
        // Person memory p1 = Person("李四",30,add);
    }
}