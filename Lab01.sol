// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
1. Limit the number of proposalNames to 4;
2. To vote is mandatory to send some wei/gwei/.../eth (min. 100/1000);
3. The amount of wei/gwei/.../eth are collected by the owner of the smart contract;
4. Keep the "state" of the amount spent from the users that will vote;
*/


/** 
 * @title Ballot
 * @dev Implements voting process along with vote delegation
 */
contract Ballot {
   
    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        address delegate; // person delegated to
        uint vote;   // index of the voted proposal
        uint amount; // amount spent
    }

    struct Proposal {
        // If you can limit the length to a certain number of bytes, 
        // always use one of bytes1 to bytes32 because they are much cheaper
        string name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    address payable public chairperson;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    // 1,000,000,000 wei = 1 gwei
    uint minFees = 1000000000;

    /** 
     *  Create a new ballot to choose one of 'proposalNames'.
     */
    constructor(string memory op_1, string memory op_2, string memory op_3, string memory op_4) {
        chairperson = payable(msg.sender);

        proposals.push(Proposal(op_1, 0));
        proposals.push(Proposal(op_2, 0));
        proposals.push(Proposal(op_3, 0));
        proposals.push(Proposal(op_4, 0));
    }

    modifier isOwner() {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        _;
    }
    
    /** 
     * @dev Give 'voter' the right to vote on this ballot. May only be called by 'chairperson'.
     * @param voter address of voter
     */
    function giveRightToVote(address voter) public isOwner {
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    /**
     * @dev Delegate your vote to the voter 'to'.
     * @param to address to which vote is delegated
     */
    function delegate(address to) public {
        Voter storage sender = voters[msg.sender];

        require(!sender.voted, "You already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // We found a loop in the delegation, not allowed.
            require(to != msg.sender, "Found loop in delegation.");
        }

        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate_.weight += sender.weight;
        }
    }

    /**
     * @dev Give your vote (including votes delegated to you) to proposal 'proposals[proposal].name'.
     * @param proposal index of proposal in the proposals array
     */
    function vote(uint proposal) public payable {
        Voter storage sender = voters[msg.sender];

        //min amount of gwei!!!
        require(msg.value >= minFees, "non-sufficient funds");

        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        
        sender.voted = true;
        sender.vote = proposal;

        // Keep the amount sent by the voter
        sender.amount = msg.value;

        // Send the amount to the chairperson wallet
        chairperson.transfer(msg.value);

        // If 'proposal' is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += sender.weight;
    }

    /** 
     * @dev Computes the winning proposal taking all previous votes into account.
     * @return winningProposal_ index of winning proposal in the proposals array
     */
    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    /** 
     * @dev Calls winningProposal() function to get the index of the winner contained in the proposals array and then
     * @return winnerName_ the name of the winner
     */
    function winnerName() public view
            returns (string memory winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }

}
