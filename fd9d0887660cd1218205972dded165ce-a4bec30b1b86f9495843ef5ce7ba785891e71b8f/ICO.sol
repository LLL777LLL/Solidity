 pragma solidity ^0.4.18;

    interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }

    contract TokenERC20 {
        string public name;             //代币名称
        string public symbol;           //代币符号
        uint8 public decimals = 18;     // decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值
        uint256 public totalSupply;     //发行总量

        // 用mapping保存每个地址对应的余额
        mapping (address => uint256) public balanceOf;
        
        // 存储对账号的控制，用来授权使用
        mapping (address => mapping (address => uint256)) public allowance;

        // 事件，用来通知客户端交易发生
        event Transfer(address indexed from, address indexed to, uint256 value);

        // 事件，用来通知客户端代币被消费
        event Burn(address indexed from, uint256 value);

        /**
         * 初始化构造
         */
        constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
            totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
            balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
            name = tokenName;                                   // 代币名称
            symbol = tokenSymbol;                               // 代币符号
        }

        /**
         * 代币交易转移的内部实现
         */
        function _transfer(address _from, address _to, uint _value) internal {
            // 确保目标地址不为0x0，因为0x0地址代表销毁
            require(_to != 0x0);
            // 检查发送者余额
            require(balanceOf[_from] >= _value);
            // 溢出检查
            require(balanceOf[_to] + _value > balanceOf[_to]);

            // 以下用来检查交易，
            uint previousBalances = balanceOf[_from] + balanceOf[_to];
            // 转账发起者的代币余额减去value
            balanceOf[_from] -= _value;
            // 转账接收者的代币余额加上value
            balanceOf[_to] += _value;
            
            emit Transfer(_from, _to, _value);

            // 用assert来检查代码逻辑。
            assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
        }

        /**
         *  代币转账
         * 从自己账号发送`_value`个代币到 `_to`账号
         *
         * @param _to 接收者地址
         * @param _value 转移数额
         */
        function transfer(address _to, uint256 _value) public {
            _transfer(msg.sender, _to, _value);                 //调用转账函数
        }

        /**
         * 代币转账被授权的第三方的人去使用授权人的代币时调用
         * @param _from         授权人的地址
         * @param _to           接收者地址
         * @param _value        转移数额
         * @param msg.sender    当前函数调用者的地址
         */
        function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
            require(_value <= allowance[_from][msg.sender]);        // 判断转账数额是否超过我（msg.sender，被授权人）所能控制的份额
            allowance[_from][msg.sender] -= _value;                 //从授权份额中减去
            _transfer(_from, _to, _value);                          //调用转账函数
            return true;
        }

        /**
         * 设置代理人，允许_spender所花费我（msg.sender）的代币
         *
         * 允许发送者`_spender` 花费不多于 `_value` 个代币
         *
         * @param _spender  被授权使用的地址
         * @param _value    可以使用的代币数量
         */
        function approve(address _spender, uint256 _value) public returns (bool success) {
            allowance[msg.sender][_spender] = _value;
            return true;
        }

        /**
         * 设置允许一个地址（_spender）以我（msg.sender）的名义花费的代币。
         *
         * @param _spender      被授权使用的地址
         * @param _value        可以使用的代币数量
         * @param _extraData    发送给合约的附加数据
         */
        function approveAndCall(address _spender, uint256 _value, bytes _extraData)public returns (bool success) {
            tokenRecipient spender = tokenRecipient(_spender);
            if (approve(_spender, _value)) {
                // 通知合约
                spender.receiveApproval(msg.sender, _value, this, _extraData);
                return true;
            }
        }

        /**
         * 销毁我，当前函数的调用者的代币。
         */
        function burn(uint256 _value) public returns (bool success) {
            require(balanceOf[msg.sender] >= _value);   // 判断账户中的余额是否超过要销毁的数额
            balanceOf[msg.sender] -= _value;            // 从余额中减去
            totalSupply -= _value;                      // 发行总量中减去
            emit Burn(msg.sender, _value);
            return true;
        }

        /**
         * 销毁被我所代理的代币，第三方调用。
         *
         * 销毁被我所代理的人的代币，
         *
         * @param _from         代理人的地址
         * @param _value the    销毁的数量
         */
        function burnFrom(address _from, uint256 _value) public returns (bool success) {
            require(balanceOf[_from] >= _value);                // 被代理人（from）的余额
            require(_value <= allowance[_from][msg.sender]);    // 判断我（msg.sender）持有from的代币数量是否大于value
            balanceOf[_from] -= _value;                         // 从被代理人（from）余额中扣除
            allowance[_from][msg.sender] -= _value;             // 从我（msg.sender）代理的份额中扣除
            totalSupply -= _value;                              // 发行总量减去
            emit Burn(_from, _value);
            return true;
        }
    }
