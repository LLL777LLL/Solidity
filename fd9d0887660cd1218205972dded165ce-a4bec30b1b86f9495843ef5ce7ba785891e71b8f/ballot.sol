pragma solidity ^0.4.0;
contract Ballot {
    struct Voter {
        //投票者所占的票数
        uint weight;
        //是否是否已经投过票
        bool voted;
        //投票对应的提案编号
        uint8 vote;
        //投票者的委托对象
        address delegate;
    }
    struct Proposal {
        //提案的票数 
        uint voteCount;
    }
    //投票的主持人
    address chairperson;
    
    //投票者地址和状态对应的关系 
    mapping(address => Voter) voters;
    
    //几个提案
    Proposal[] proposals;

    ///创建一个新的（投票）表决。
    constructor (uint8 _numProposals) public {
        //将投票发起者设置为主持人，并赋予投票权利作为投票者  
        chairperson = msg.sender;
        
        voters[chairperson].weight = 1;
        
        proposals.length = _numProposals;
    }


    /// Give $(toVoter) the right to vote on this ballot.
    /// May only be called by $(chairperson).
    //赋予选举权
    function giveRightToVote(address toVoter) public {
        //赋予投票权利
        if (msg.sender != chairperson || voters[toVoter].voted) return;
        voters[toVoter].weight = 1;
    }

    /// Delegate your vote to the voter $(to).
    //把你的选票委托给选民to。
    function delegate(address to) public {
        
        Voter storage sender = voters[msg.sender]; // assigns reference
        //如果投过票退出
        if (sender.voted) return;
        
        //判断被委托人是否把投票权利委托给了其他人，如果是，找到被委托人投票权利的所属人
        while (voters[to].delegate != address(0) && voters[to].delegate != msg.sender)
            to = voters[to].delegate;
        
        //不能委托给自己
        if (to == msg.sender) return;
        
        sender.voted = true;
        sender.delegate = to;
        
        Voter storage delegateTo = voters[to];
        
        //若被委托者已经投过票了，直接增加他投给的那人的得票数
        if (delegateTo.voted)
            proposals[delegateTo.vote].voteCount += sender.weight;
        else
            //如果没有增加他持有的票数
            delegateTo.weight += sender.weight;
    }

    /// Give a single vote to proposal $(toProposal).
    //对 toProposal 投票
    function vote(uint8 toProposal) public {
        Voter storage sender = voters[msg.sender];
        //所投票提案必须存在 
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
    }
    //获取得到票数最多的提案编号 
    function winningProposal() public constant returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
    }
}