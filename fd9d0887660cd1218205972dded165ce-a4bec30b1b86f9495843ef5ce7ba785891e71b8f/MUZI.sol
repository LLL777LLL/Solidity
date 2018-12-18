    pragma solidity ^0.4.16;

    interface mytoken {
        function transfer(address receiver, uint amount) external;
    }

    contract Crowdsale {
        address public beneficiary;     // 募资成功后的收款方
        uint public fundingGoal;        // 募资额度
        uint public amountRaised;       // 募资高度（已募资多少钱）
        uint public deadline;           // 募资截止期

        uint public price;    //  token 与以太坊的汇率 , token卖多少钱
        mytoken public tokenReward;   // 要卖的token

        mapping(address => uint256) public balanceOf;

        bool fundingGoalReached = false;  // 众筹是否达到目标
        bool crowdsaleClosed = false;   //  众筹是否结束

        /**
        * 事件可以用来跟踪信息
        **/
        event GoalReached(address recipient, uint totalAmountRaised);
        event FundTransfer(address backer, uint amount, bool isContribution);

        /**
         * 构造函数, 设置相关属性
         */
        constructor(
            address ifSuccessfulSendTo,
            uint fundingGoalInEthers,
            uint durationInMinutes,
            uint finneyCostOfEachToken,
            address addressOfTokenUsedAsReward) public {
                beneficiary = ifSuccessfulSendTo;                     //设置募资收款方地址
                fundingGoal = fundingGoalInEthers * 1 ether;          //设置募资总额度
                deadline = now + durationInMinutes * 1 minutes;       //设置募资截止日期
                price = finneyCostOfEachToken * 1 finney;             //其中1 ether = 1000 finney
                tokenReward = mytoken(addressOfTokenUsedAsReward);    // 传入已发布的 token 合约的地址来创建实例
        }

        /**
         * 无函数名的Fallback函数，
         * 在向合约转账时，这个函数会被调用
         */
        function () public payable {
            require(!crowdsaleClosed);                        //判断募资是否结束
            uint amount = msg.value;                          //如果还没有结束，将收到的金额保存到amount中
            balanceOf[msg.sender] += amount;                  //保存参募者的金额，其对应地址上的金额
            amountRaised += amount;                           //同时把已募资的高度增加
            tokenReward.transfer(msg.sender, amount / price); //其中“amount / price”是将finney换算成ether
            emit FundTransfer(msg.sender, amount, true);      //时间处理
        }

        /**
        *  定义函数修改器modifier（作用和Python的装饰器很相似）
        * 用于在函数执行前检查某种前置条件（判断通过之后才会继续执行该方法）
        * _ 表示继续执行之后的代码
        **/
        modifier afterDeadline() { if (now >= deadline) _; }//判断时候已经过了期限，注意这里的if并没有大括号

        /**
         * 判断众筹是否完成融资目标， 这个方法使用了afterDeadline函数修改器
         *
         */
        function checkGoalReached() public afterDeadline {  //这个函数应该在safeWithdrawal函数之前调用，不然时间过了，直接调用safeWithdrawal就会将钱退换
            if (amountRaised >= fundingGoal) {              //判断募资高度是否大于募资总金额
                fundingGoalReached = true;                  //表示已募资成功
                emit GoalReached(beneficiary, amountRaised);
            }
            crowdsaleClosed = true;                         //募资结束，这里并不一定是募资成功，但是募资期限已过
        }


        /**
         * 完成融资目标时，融资款发送到收款方
         * 未完成融资目标时，执行退款
         *
         */
        function safeWithdrawal() public afterDeadline {              //由于这个函数有afterDeadline修饰，所以这个函数只有在事件截止才成功
            if (!fundingGoalReached) {                                //判断是否达到目标，这个条件就是当募资失败就把钱回给参募者
                uint amount = balanceOf[msg.sender];                  //将调用此函数的地址所对应的余额保存到amount中
                balanceOf[msg.sender] = 0;                            //将调用者的余额设置为0
                if (amount > 0) {                                     //判断amount是否大于0
                    if (msg.sender.send(amount)) {                    //将钱发给调用者并判断是否成功
                        emit FundTransfer(msg.sender, amount, false); //事件
                    } else {
                        balanceOf[msg.sender] = amount;               //如果失败，将余额重新保存到调用者的地址中
                    }
                }
            }

            if (fundingGoalReached && beneficiary == msg.sender) {        //判断募资是否成功并且判断调用者是否是收款方
                if (beneficiary.send(amountRaised)) {                     //将已募资成功的所有金额发送到收款方，并判断是否成功
                    emit FundTransfer(beneficiary, amountRaised, false);  //事件
                } else {
                    //If we fail to send the funds to beneficiary, unlock funders balance
                    fundingGoalReached = false;                           //这里感觉不对，还差，如果收款并没有成功呢
                }
            }
        }
    }
