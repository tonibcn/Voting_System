//SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;


// -----------------------------------
//  CANDIDATE   |   AGE   |      ID
// -----------------------------------
//  Toni        |    20    |    12345X
//  Alberto     |    23    |    54321T
//  Joan        |    21    |    98765P
//  Javier      |    19    |    56789W

//Start contract
contract vote_contract { 
    
    //Owner
    address owner;
    
    //constructor; condition owner = address who execute 1rst time
   constructor () public {
       owner = msg.sender;
   }
    
    //Relation between name of candidates and his personal data
    mapping (string => bytes32) Map_Id_candidate;
    
    //Relation between candidates and number of votes they have received
    mapping (string => uint) Map_votes_candidate;
    
    //List with candidates names
    string [] candidates;
    
    //List with hash id of voters
    bytes32 [] voters;
    
    
    //Everyone can use this function for being a candidate
    function candidate (string memory _name_candidate, uint age_candidate, string memory _id_candidate) public {

        //Candidate Hash id 
        bytes32 Hash_Id_candidate = keccak256(abi.encodePacked(_name_candidate,age_candidate,_id_candidate)) ;

        //Save the hash associate with the name of the candidate
        Map_Id_candidate[_name_candidate] = Hash_Id_candidate; 

        //Save the candidate's name to candidate's list
        candidates.push(_name_candidate);

     }
    
    //Allow to see candidates
    function see_candidates () public view returns (string[] memory) { 
        //Return candidates
        return candidates;
    }
    //Function to vote
    function vote (string memory _name_candidate) public    { 
        
        //Voter direction hash
         bytes32 hash_voter = keccak256(abi.encodePacked(msg.sender));
        //Verify if a voter voted before and if the candidate exist (bucle for)
        for (uint i= 0; i< voters.length;i++) {
            require(voters[i]!= hash_voter, "You have voted before") ;
        }
        //In case the voter didn't vote before, we add his hash address to the array of voters
        voters.push(hash_voter);
        //Add the vote to the candidate, only one time per user
        Map_votes_candidate[_name_candidate]++ ;
}
    
    //Function that returns the number of votes one candidate recieve
    function see_votes (string memory _name_candidate) public view returns (uint) {
        //Returns number of votes 
        return(Map_votes_candidate[_name_candidate]);

    }
    
    //Auxiliar function to trasnform uint into string
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
    
    
    //Function to see all the votes for each candidate
        //We save in a string variable the candidates and it's votes
    function See_results () public view returns ( string memory)     { 
        
        //We save in a string variable candidate's with his votes Recorremos el array de candidatos para actualizar el string resultados
        string memory results = "";
            //Actualizamos el string resultados y añadimos el candidato que ocupa la posicion "i" del array candidatos
            //We use function see_votes to add number of votes in the function
            //We use auxiliar function
            for (uint i= 0; i < candidates.length; i++) {
                results = string(abi.encodePacked (results, "(", candidates[i], ", ", uint2str(see_votes(candidates[i])), ")----" )) ;
            }
    
            return results;
     
    }
    
    //Function that return the winner
    function Winner () public view returns (string memory) {

        //Variable that contais winner. At first we equalize this variable to first candidate in array
        string memory winner = candidates[0] ;
        //Variable used in case of tie
        bool flag;
        //We run candidate's array 
        //We use candidates[0] in order to obtain candidate's most voted
        for (uint i= 1; i< candidates.length; i++) {
            if (Map_votes_candidate[winner] < Map_votes_candidate[candidates[i]]) {
            winner =  candidates[i];
            flag = false;
            } else {
                //In case they have the same votes
                if (Map_votes_candidate[winner] == Map_votes_candidate[candidates[i]]) {
                flag = true;
                }

            }
        
        }
        //We check if there is a tie
            if (flag == true) {
                winner = "there is a tie between the candidates";
            }
        //Return winner
        return winner;
        }
    
}
