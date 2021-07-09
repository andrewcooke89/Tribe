// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "./tribeHelper.sol";

contract Tribe is TribeHelpers {
  counter++;
  Chief memory newChief = Chief(counter, "Chief", block.timestamp, 0);

  function createTribe() external {
    tribeList[msg.sender] = Tribe(
      1,
      5,
      0,
      0,
      0,
      0,
      0,
      0,
      false,
      1,
      0,
      0,
      0,
      People(new Shaman[](0), new TribesPerson[](0), new Elder[](0), newChief)
    );
    counter++;
    tribeList[msg.sender].tribesPeople.tribesPerson.push(TribesPerson(counter,'Carpenter', block.timestamp, 0));
    counter++;
    tribeList[msg.sender].tribesPeople.tribesPerson.push(TribesPerson(counter,'Gatherer', block.timestamp, 0));
    counter++;
    tribeList[msg.sender].tribesPeople.tribesPerson.push(TribesPerson(counter,'Gatherer', block.timestamp, 0));
    counter++;
    tribeList[msg.sender].tribesPeople.tribesPerson.push(TribesPerson(counter,'Berzerker', block.timestamp, 0));
  }
}

