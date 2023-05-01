// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ElectionFact {
    
    struct ElectionDet {
        string electionId;
        address deployedAddress;// who create this election like admin
        string electionName; 
        uint  createdDate ;
        string electionDesc;
        }

        
    // map each election with their id
    mapping(string=>ElectionDet) Elections;
    // make a array to store each election
    ElectionDet[] allElection;


    function createElection(string memory electionId,string memory electionName, string memory electionDesc) public{

        address newElection = new Election(msg.sender , electionId,electionName, electionDesc);
        Elections[electionId].electionId = electionId;
        Elections[electionId].deployedAddress = newElection;
        Elections[electionId].electionName = electionName;
        Elections[electionId].createdDate = block.timestamp;
        Elections[electionId].electionDesc = electionDesc;
  

        // now add this election in array
        allElection.push(ElectionDet(electionId,newElection,electionName,block.timestamp,electionName));
    
    }

    // now make a function for get all election 
    function getAllElection() public view returns(ElectionDet[] memory)
    {
    return allElection;
    }
    
    // now make a function for single elction
    function getElection(string memory electionId) public view returns(string memory,address,string memory,uint,string memory) {
        address val =  Elections[electionId].deployedAddress;
        if(val == 0) 
            return (0,"","Create an election.");
        else
            return (
                 Elections[electionId].electionId,
                 Elections[electionId].deployedAddress ,
                 Elections[electionId].electionName,
                 Elections[electionId].createdDate,
                 Elections[electionId].electionDesc);
    }
}





// function 
// register of voter
// getAllCandidateData
// register of voter 
//







contract Election {

    //election_authority's address
    address electionAuthority;
    string electionNam;
    string electionDesc;
    uint electionId;
    
  

   // now make a struk for candidate

   struct Candidate{
       uint candidateId;
       string name;
       string party;
       string age;
       uint voteCount;
   }
   
   // store candidate  in map
   mapping (uint => Candidate)  public Candidates;
   
//total no of candidate 
    uint public candidateCount;



   // Now about the voter 
   struct Voter{
       string voterId;
       bool isRegister;
       bool hasVoted;
   }
   
// map each voter with  address
   mapping(address => Voter) public voters;

// total no of voter 
  uint public voterCount;
  // total no of voter who done voting
  uint public  votedVoter;


  // make phase
  enum PHASE {reg,voting, result}
  PHASE public state;


  modifier onlyAdmin() {
      require(msg.sender ==electionAuthority );
      _;
     }

   



   modifier validState(PHASE x)
   {
       require(state== x);
       _;
   }




  //election_authority's address taken when it deploys the contract
    constructor(address authority ,string memory id, string memory name, string memory description) public {
        electionAuthority = authority;
        electionNam = name;
        electionDesc = description;
        electionId =  id;
        state = PHASE.reg;
    }

    // change the state 
    
    function changeState(PHASE x) onlyAdmin public{
		require(x > state,"not able to change the state");
        state = x;
    }

    // add candidate 
    function addCandidate(uint id,string memory name, string memory party,uint age ) public onlyAdmin validState(PHASE.reg)
    { 
        Candidates[id] = Candidate(id,name,party,age,0);
        candidateCount++;
    }
    
    // getAll candidateList 



   // getSingle candidate



   // voter registeration 
   function voterRegistration(address user) public  validState(PHASE.reg){
       voters[user].isRegister=true;
       voterCount++;
       
   }



   //voting function
   function vote(uint candidateId) public validState(PHASE.voting)
   {
       require(voters[msg.sender].isRegister,"you are not register");
       require(!voters[msg.sender].hasVoted,"you already voted");
       require(candidateId > 0 && candidateId <= candidateCount," please choose to valid candidate");
       Candidates[candidateId].voteCount ++;
       
       voters[msg.sender].hasVoted = true;
       votedVoter++;
       
   }

    //function to return winner candidate information

    function winnerCandidate() public  onlyAdmin validState(PHASE.result) returns (uint8) {
        uint8 largestVotes = Candidates[0].voteCount;
        uint8 candidateID;

        return candidateID;
       
    }
}