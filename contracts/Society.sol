pragma solidity ^0.4.8;

import "./Owned.sol";

contract Society is owned {

  mapping (address => uint) public memberId;
  Member[] public members;

  event MembershipChanged(address member, bool isMember);

  struct Member {
      address member;
      string name;
      uint memberSince;
  }

  /*make member*/
  function addMember(address targetMember, string memberName) onlyOwner {
      uint id;
      if (memberId[targetMember] == 0) {
         memberId[targetMember] = members.length;
         id = members.length++;
         members[id] = Member({member: targetMember, memberSince: now, name: memberName});
      } else {
          id = memberId[targetMember];
          /*Member m = members[id];*/
      }

      MembershipChanged(targetMember, true);
  }

  function removeMember(address targetMember) onlyOwner {
      if (memberId[targetMember] == 0) throw;

      for (uint i = memberId[targetMember]; i<members.length-1; i++){
          members[i] = members[i+1];
      }
      delete members[members.length-1];
      members.length--;

    MembershipChanged(targetMember, false);
  }

  /* modifier that allows only shareholders to vote and create new proposals */
  modifier onlyMembers {
      if (memberId[msg.sender] == 0)
      throw;
      _;
  }

}