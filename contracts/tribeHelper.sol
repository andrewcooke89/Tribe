// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "./store.sol";

contract TribeHelpers is Store {

  function createTribesPerson (string memory _role) internal {
    bytes32 roleHash = keccak256(abi.encodePacked(_role));
    bytes32 shamHash = keccak256(abi.encodePacked("Shaman"));
    bytes32 shamanElderHash = keccak256(abi.encodePacked("ShamanElder"));
    bytes32 witchElderHash = keccak256(abi.encodePacked("WitchElder"));
    bytes32 generalElderHash = keccak256(abi.encodePacked("GeneralElder"));
    
    if (roleHash != shamHash || roleHash != shamanElderHash || roleHash != generalElderHash || roleHash != witchElderHash) {
      counter++;
      tribeList[msg.sender].tribesPeople.tribesPerson.push(TribesPerson(counter,_role, block.timestamp, 0));
    } else if (roleHash == shamHash) {
      require(tribeList[msg.sender].shamanHouse > tribeList[msg.sender].tribesPeople.shaman.length);
      counter++;
      tribeList[msg.sender].tribesPeople.shaman.push(Shaman(_role,counter, block.timestamp, 0, 0, 0, 0, 0));
    } else if (roleHash == shamanElderHash || roleHash == witchElderHash || roleHash == generalElderHash) {
      counter++;
      tribeList[msg.sender].tribesPeople.elder.push(Elder(counter,_role, block.timestamp, 0));
    }
  }

  function getTribe() public view returns (Tribe memory) {
    return tribeList[msg.sender];
  }

  function strKeccak(string memory _string) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked(_string));
  }

  function compareStr (string memory _str, string memory _str2) internal pure returns (bool) {
    return strKeccak(_str) == strKeccak(_str2);
  }

  function updateResources() internal {
    for (uint i = 0; i < tribeList[msg.sender].tribesPeople.tribesPerson.length; i++) {
      if (strKeccak(tribeList[msg.sender].tribesPeople.tribesPerson[i].role) == strKeccak('Gatherer')) {
        tribeList[msg.sender].foodCount++;
      } else if (strKeccak(tribeList[msg.sender].tribesPeople.tribesPerson[i].role) == strKeccak('Carpenter')) {
        tribeList[msg.sender].woodCount++;
      } else if (strKeccak(tribeList[msg.sender].tribesPeople.tribesPerson[i].role) == strKeccak('Hunter')) {
        tribeList[msg.sender].meatCount++;
      }
    }
    tribeList[msg.sender].lastCollected = block.timestamp;
  }

  function gatherResources() public returns (Tribe memory) {
    uint prevCollected = tribeList[msg.sender].lastCollected;
    if (
      prevCollected == 0 ||
      prevCollected + 1 days <= block.timestamp
    ) {
      updateResources();
    }
    return tribeList[msg.sender];
  }

  // TODO test this function to ensure functionality
  function generateRandNumber () internal view returns (uint8) {
    return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%11);
  }

  function generateFromTwoOptions (string memory _role, uint8 percent1, string memory _role2, uint8 rand) internal returns (string memory) {
    if (rand <= percent1) {
      createTribesPerson(_role);
      return _role;
    } else {
      createTribesPerson(_role2);
      return _role2;
    }
  }

  function generateFromThreeOptions (string memory _role, uint8 percent1, string memory _role2, uint8 percent2, string memory _role3 , uint8 rand) internal returns (string memory) {
    if (rand <= percent1) {
      createTribesPerson(_role);
      return _role;
    } else if (rand > percent1 && rand <= percent2) {
      createTribesPerson(_role2);
      return _role2;
    } else {
      createTribesPerson(_role3);
      return _role2;
    }
  }

  function generateFromGeneral (string memory _role, uint percent1, string memory _role2, uint8 rand) internal returns (string memory) {
    if (rand <= percent1) {
      createTribesPerson(_role);
      createTribesPerson(_role);
      return _role;
    } else {
      createTribesPerson(_role2);
      return _role2;
    }
  }

  function breedPair(string memory _personOneRole, string memory _personTwoRole) internal returns (string memory) {
    uint8 rand = generateRandNumber();
    // if person one is gatherer, check pair
    if (compareStr(_personOneRole, "Gatherer")) {
      if (compareStr(_personTwoRole, "Berserker")) {
        return generateFromTwoOptions("Gatherer",50, "Berserker", rand);
      } else if (compareStr(_personTwoRole, "Carpenter")) {
        return generateFromTwoOptions("Gatherer",50, "Carpenter", rand);
      } else if (compareStr(_personTwoRole, "Hunter")) {
        return generateFromTwoOptions("Gatherer",50, "Hunter", rand);
      } else if (compareStr(_personTwoRole, "Chief")) {
        return generateFromTwoOptions("Teacher",75, "Gatherer", rand);
      } else if (compareStr(_personTwoRole, "General")) {
        generateFromGeneral("Gatherer", 50, "Hunter", rand);
      } else if (compareStr(_personTwoRole, "Archer")) {
        return generateFromTwoOptions("Gatherer",50, "Archer", rand);
      } else if (compareStr(_personTwoRole, "Gatherer")) {
        createTribesPerson("Gatherer");
        return "Gatherer";
      } else if (compareStr(_personTwoRole, "Teacher")) {
        return generateFromThreeOptions("Hunter", 45, "Gatherer", 45, "Teacher", rand);
      } else if (compareStr(_personTwoRole, "Witch")) {
        return generateFromTwoOptions("Gatherer",85, "Witch", rand);
      } 

      // if it's a Berserker, check pair
    } else if (compareStr(_personOneRole, "Berserker")) {
      if (compareStr(_personTwoRole, "Berserker")) {
        createTribesPerson("Berserker");
        return "Berserker";
      } else if (compareStr(_personTwoRole, "Carpenter")) {
        return generateFromTwoOptions("Berserker",50, "Carpenter", rand);
      } else if (compareStr(_personTwoRole, "Hunter")) {
        return generateFromTwoOptions("Berserker",50, "Hunter", rand);
      } else if (compareStr(_personTwoRole, "Chief")) {
        return generateFromTwoOptions("General",75, "Berserker", rand);
      } else if (compareStr(_personTwoRole, "General")) {
        generateFromGeneral("Berserker", 30, "Berserker", rand);
      } else if (compareStr(_personTwoRole, "Archer")) {
        return generateFromTwoOptions("Berserker",50, "Archer", rand);
      } else if (compareStr(_personTwoRole, "Gatherer")) {
        return generateFromTwoOptions("Berserker",50, "Gatherer", rand);
      } else if (compareStr(_personTwoRole, "Teacher")) {
        return generateFromThreeOptions("Berserker", 50, "Archer", 45, "Witch", rand);
      } else if (compareStr(_personTwoRole, "Witch")) {
        return generateFromTwoOptions("Witch",15, "Berserker", rand);
      } 
    // if it's a hunter, check pair
    } else if (compareStr(_personOneRole, "Hunter")) {
      if (compareStr(_personTwoRole, "Berserker")) {
        return generateFromTwoOptions("Hunter",50, "Berserker", rand);
      } else if (compareStr(_personTwoRole, "Carpenter")) {
        return generateFromTwoOptions("Hunter",50, "Carpenter", rand);
      } else if (compareStr(_personTwoRole, "Hunter")) {
        createTribesPerson("Hunter");
        return "Hunter";
      } else if (compareStr(_personTwoRole, "Chief")) {
        return generateFromTwoOptions("Hunter",25, "Chief", rand);
      } else if (compareStr(_personTwoRole, "General")) {
        generateFromGeneral("Hunter", 30, "Archer", rand);
      } else if (compareStr(_personTwoRole, "Archer")) {
        return generateFromTwoOptions("Hunter",50, "Archer", rand);
      } else if (compareStr(_personTwoRole, "Gatherer")) {
        return generateFromTwoOptions("Hunter",50, "Gatherer", rand);
      } else if (compareStr(_personTwoRole, "Teacher")) {
        return generateFromThreeOptions("Hunter", 45, "Gatherer", 45, "Teacher", rand);
      } else if (compareStr(_personTwoRole, "Witch")) {
        return generateFromTwoOptions("Hunter",85, "Witch", rand);
      } 
    // if it's carpenter, check pair
    } else if (compareStr(_personOneRole, "Carpenter")) {
      if (compareStr(_personTwoRole, "Berserker")) {
        return generateFromTwoOptions("Carpenter",50, "Berserker", rand);
      } else if (compareStr(_personTwoRole, "Carpenter")) {
        createTribesPerson("Carpenter");
        return "Carpenter";
      } else if (compareStr(_personTwoRole, "Hunter")) {
        return generateFromTwoOptions("Carpenter",50, "Hunter", rand);
      } else if (compareStr(_personTwoRole, "Chief")) {
        return generateFromTwoOptions("Carpenter",15, "Teacher", rand);
      } else if (compareStr(_personTwoRole, "General")) {
        generateFromGeneral("Carpenter", 30, "Carpenter", rand);
      } else if (compareStr(_personTwoRole, "Archer")) {
        return generateFromTwoOptions("Carpenter",50, "Archer", rand);
      } else if (compareStr(_personTwoRole, "Gatherer")) {
        return generateFromTwoOptions("Carpenter",50, "Gatherer", rand);
      } else if (compareStr(_personTwoRole, "Teacher")) {
        return generateFromTwoOptions("Teacher",25, "Carpenter", rand);
      } else if (compareStr(_personTwoRole, "Witch")) {
        return generateFromTwoOptions("Witch",15, "Carpenter", rand);
      } 
      // if it's a teacher, check pair
    } else if (compareStr(_personOneRole, "Teacher")) {
      if (compareStr(_personTwoRole, "Berserker")) {
        return generateFromThreeOptions("Berserker", 50, "Archer", 45, "Witch", rand);
      } else if (compareStr(_personTwoRole, "Carpenter")) {
        return generateFromTwoOptions("Teacher",10, "Carpenter", rand);
      } else if (compareStr(_personTwoRole, "Hunter")) {
        return generateFromThreeOptions("Hunter", 45, "Gatherer", 45, "Teacher", rand);
      } else if (compareStr(_personTwoRole, "Chief")) {
        return generateFromThreeOptions("General", 50, "Shaman", 30, "GeneralElder", rand);
      } else if (compareStr(_personTwoRole, "General")) {
        return generateFromThreeOptions("Archer", 50, "General", 20, "Teacher", rand);
      } else if (compareStr(_personTwoRole, "Archer")) {
        return generateFromTwoOptions("Archer",75, "Teacher", rand);
      } else if (compareStr(_personTwoRole, "Gatherer")) {
        return generateFromThreeOptions("Hunter", 45, "Gatherer", 45, "Teacher", rand);
      } else if (compareStr(_personTwoRole, "Teacher")) {
        createTribesPerson("Teacher");
        return "Teacher";
      } else if (compareStr(_personTwoRole, "Witch")) {
        return generateFromTwoOptions("Witch",95, "Shaman", rand);
      } 
      // if it's a witch, check pair
    } else if (compareStr(_personOneRole, "Witch")) {
      if (compareStr(_personTwoRole, "Berserker")) {
        return generateFromTwoOptions("Witch",15, "Berserker", rand);
      } else if (compareStr(_personTwoRole, "Carpenter")) {
        return generateFromTwoOptions("Witch",85, "Carpenter", rand);
      } else if (compareStr(_personTwoRole, "Hunter")) {
        return generateFromTwoOptions("Witch",15, "Hunter", rand);
      } else if (compareStr(_personTwoRole, "Chief")) {
        return generateFromTwoOptions("WitchElder",20, "Witch", rand);
      } else if (compareStr(_personTwoRole, "General")) {
        return generateFromTwoOptions("General",20, "Witch", rand);
      } else if (compareStr(_personTwoRole, "Archer")) {
        return generateFromTwoOptions("Archer",85, "Witch", rand);
      } else if (compareStr(_personTwoRole, "Gatherer")) {
        return generateFromTwoOptions("Gatherer",85, "Witch", rand);
      } else if (compareStr(_personTwoRole, "Teacher")) {
        return generateFromTwoOptions("Shaman",5, "Witch", rand);
      } else if (compareStr(_personTwoRole, "Witch")) {
        createTribesPerson("Witch");
        return "Witch";
      } 
    // if it's a general, check pair
    } else if (compareStr(_personOneRole, "General")) {
      if (compareStr(_personTwoRole, "Berserker")) {
        generateFromGeneral("Berserker", 30, "Berserker", rand);
      } else if (compareStr(_personTwoRole, "Carpenter")) {
        generateFromGeneral("Carpenter", 30, "Carpenter", rand);
      } else if (compareStr(_personTwoRole, "Hunter")) {
        generateFromGeneral("Hunter", 30, "Archer", rand);
      } else if (compareStr(_personTwoRole, "Chief")) {
        return generateFromTwoOptions("WarElder",20, "General", rand);
      } else if (compareStr(_personTwoRole, "General")) {
        createTribesPerson("General");
        return "General";
      } else if (compareStr(_personTwoRole, "Archer")) {
        generateFromGeneral("Archer", 30, "Archer", rand);
      } else if (compareStr(_personTwoRole, "Gatherer")) {
        generateFromGeneral("Gatherer", 30, "Hunter", rand);
      } else if (compareStr(_personTwoRole, "Teacher")) {
        return generateFromThreeOptions("Archer", 50, "General", 20, "Teacher", rand);
      } else if (compareStr(_personTwoRole, "Witch")) {
        return generateFromTwoOptions("Ganeral",20, "Witch", rand);
      } 
    // if its a archer check pair
    } else if (compareStr(_personOneRole, "Archer")) {
      if (compareStr(_personTwoRole, "Berserker")) {
        return generateFromTwoOptions("Archer",50, "Berserker", rand);
      } else if (compareStr(_personTwoRole, "Carpenter")) {
        return generateFromTwoOptions("Archer",50, "Carpenter", rand);
      } else if (compareStr(_personTwoRole, "Hunter")) {
        return generateFromTwoOptions("Archer",50, "Hunter", rand);
      } else if (compareStr(_personTwoRole, "Chief")) {
        return generateFromTwoOptions("General",75, "Archer", rand);
      } else if (compareStr(_personTwoRole, "General")) {
        generateFromGeneral("Archer", 30, "Archer", rand);
      } else if (compareStr(_personTwoRole, "Archer")) {
        createTribesPerson("Archer");
        return "Archer";
      } else if (compareStr(_personTwoRole, "Gatherer")) {
        return generateFromTwoOptions("Archer",50, "Gatherer", rand);
      } else if (compareStr(_personTwoRole, "Teacher")) {
        return generateFromTwoOptions("Archer",75, "Teacher", rand);
      } else if (compareStr(_personTwoRole, "Witch")) {
        return generateFromTwoOptions("Archer",85, "Witch", rand);
      } 
      // if it's a Shaman, check pair
    } else if (compareStr(_personOneRole, "Shaman")) {
      if (compareStr(_personTwoRole, "Shaman")) {
        createTribesPerson("Shaman");
        return "Shaman";
      } else if (compareStr(_personTwoRole, "Chief")) {
        if (rand <= 20) {
          createTribesPerson("ShamanElder");
          return "ShamanElder";
        } else if (rand > 20 && rand <= 40) {
          createTribesPerson("Shaman");
          return "Shaman";
        } else {
          createTribesPerson("Witch");
          return "Witch";
        }
      }
      // Check if chief
    } else if (compareStr(_personOneRole, "Chief")) {
      if (compareStr(_personTwoRole, "Berserker")) {
        return generateFromTwoOptions("General",75, "Berserker", rand);
      } else if (compareStr(_personTwoRole, "Carpenter")) {
        return generateFromTwoOptions("Carpenter",25, "Teacher", rand);
      } else if (compareStr(_personTwoRole, "Hunter")) {
        return generateFromTwoOptions("Hunter",25, "Teacher", rand);
      } else if (compareStr(_personTwoRole, "General")) {
        return generateFromTwoOptions("WarElder",20, "General", rand);
      } else if (compareStr(_personTwoRole, "Archer")) {
        return generateFromTwoOptions("General",75, "Archer", rand);
      } else if (compareStr(_personTwoRole, "Gatherer")) {
        return generateFromTwoOptions("Gatherer",25, "Teacher", rand);
      } else if (compareStr(_personTwoRole, "Teacher")) {
        return generateFromThreeOptions("General", 50, "Shaman", 30, "GeneralElder", rand);
      } else if (compareStr(_personTwoRole, "Witch")) {
        return generateFromTwoOptions("WitchElder",20, "Witch", rand);
      } else if (compareStr(_personTwoRole, "Shaman")) {
        return generateFromThreeOptions("ShamanElder", 20, "Witch", 60, "Shaman", rand);
      }
    }
    return "Invalid combination";
  }

  function findFromTribesPerson(uint _personId) internal view returns (TribesPerson memory) {
    for (uint i = 0; i < tribeList[msg.sender].tribesPeople.tribesPerson.length; i++) {
      // if it's person 1
      if (tribeList[msg.sender].tribesPeople.tribesPerson[i].personId == _personId) {
        return tribeList[msg.sender].tribesPeople.tribesPerson[i];
      }
    }
  }

  function findFromShaman(uint _personId) internal view returns (Shaman memory) {
    for (uint i = 0; i < tribeList[msg.sender].tribesPeople.tribesPerson.length; i++) {
      // if it's person 1
      if (tribeList[msg.sender].tribesPeople.shaman[i].personId == _personId) {
        return tribeList[msg.sender].tribesPeople.shaman[i];
      }
    }
  }

  function breedIfValid(string memory _role1, uint personId, string memory _role2, uint personTwoId) internal returns (string memory) {
    if (personId > 0 && personTwoId > 0) {
      return breedPair(_role1, _role2);
    } else {
      return "invalid pair";
    }
  }

  function breed(uint _personId, string memory _listName, uint _personTwoId, string memory _listNameTwo) public returns (string memory) {
    // check if out of cooldown or starting value.
    if (block.timestamp  - tribeList[msg.sender].lastBreed >= 0.5 days || tribeList[msg.sender].lastBreed == 0 ) {
      // if both people are part of tribesperson
      if (compareStr(_listName, _listNameTwo) && compareStr(_listName, "tribesPerson")) {
        TribesPerson memory personOne;
        TribesPerson memory personTwo;
        // iterate over tribesPeople list looking for correct members
        for (uint i = 0; i < tribeList[msg.sender].tribesPeople.tribesPerson.length; i++) {
          // if it's person 1
          if (tribeList[msg.sender].tribesPeople.tribesPerson[i].personId == _personId) {
            personOne = tribeList[msg.sender].tribesPeople.tribesPerson[i];
          }
          // if it's person 2
          if (tribeList[msg.sender].tribesPeople.tribesPerson[i].personId == _personTwoId) {
            personTwo = tribeList[msg.sender].tribesPeople.tribesPerson[i];
          }
          // if both are found, break
          if (personOne.personId > 0 && personTwo.personId > 0) {
            break;
          }
        }
        // if both have been found
        if (personOne.personId > 0 && personTwo.personId > 0) {
          string memory res = breedPair(personOne.role, personTwo.role);
          return res;
        }
        // if first list is shaman and second list is tribesPeople
      } else if (compareStr(_listName, "Shaman") && compareStr(_listNameTwo, "tribesPerson")) {
        Shaman memory personOne = findFromShaman(_personId);
        TribesPerson memory personTwo = findFromTribesPerson(_personTwoId);
        string memory res = breedIfValid(personOne.role, personOne.personId, personTwo.role, personTwo.personId);
        
        if (!compareStr(res, "invalid pair")) {
          // TODO activate cooldowns for shaman
        }
        return res;
        
        // if first list is chief and second list is tribesPeople
      } else if (compareStr(_listName, "Chief") && compareStr(_listName, "TribesPerson")) {
        Chief memory personOne = tribeList[msg.sender].tribesPeople.chief;
        TribesPerson memory personTwo = findFromTribesPerson(_personTwoId);
        string memory res = breedIfValid(personOne.role, personOne.personId, personTwo.role, personTwo.personId);
        
        if (!compareStr(res, "invalid pair")) {
          // TODO activate cooldowns chief
        }
        return res;
        // if first list is chief and second list is shaman
      } else if (compareStr(_listName, "Chief") && compareStr(_listName, "Shaman")) {
        Chief memory personOne = tribeList[msg.sender].tribesPeople.chief;
        Shaman memory personTwo = findFromShaman(_personId);
        string memory res = breedIfValid(personOne.role, personOne.personId, personTwo.role, personTwo.personId);
      
        if (!compareStr(res, "invalid pair")) {
          // TODO activate cooldowns for chief and shaman
        }
        return res;
      }
    }
  }
}