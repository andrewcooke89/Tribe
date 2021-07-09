// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Store is Ownable {

  uint counter = 0;

  struct Tribe {
    uint level;
    uint32 foodCount;
    uint32 meatCount;
    uint32 woodCount;
    uint lastBreed;
    uint lastCollected;
    uint lastAttacked;
    uint lastTotemPole;
    bool totemPoleDestroyed;
    uint16 houseCount;
    uint8 barracksCount;
    uint8 shamanHouse;
    uint chiefBreedCD;
    People tribesPeople;
  }

  struct Shaman {
    string role;
    uint personId;
    uint birth;
    uint lastBreed;
    uint bearCD;
    uint wolfCD;
    uint bullCD;
    uint totemPoleCD;
  }

  struct TribesPerson {
    uint personId;
    string role;
    uint birth;
    uint lastBreed;
  }

  struct Elder {
    uint personId;
    string role;
    uint birth;
    uint passiveCD;
  }

  struct People {
    Shaman[] shaman;
    TribesPerson[] tribesPerson;
    Elder[] elder;
    Chief chief;
  }
  
  struct Chief {
    uint personId;
    string role;
    uint lastBreed;
  }
  // mapping (uint => Shaman) internal shamanList;
  // mapping (uint => address) internal shamanToOwner;
  // mapping (uint => TribesPerson) internal tribesPersonList;
  // mapping (uint => address) internal tribesPersonToOwner;
  // mapping (uint => Elder) internal elderList;
  // mapping (uint => address) internal elderToOwner;
  mapping (address => Tribe) public tribeList;

  // uint internal counter = 0;

}

