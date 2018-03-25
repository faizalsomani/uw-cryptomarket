pragma solidity ^0.4.18;

contract Club {
  string name;

  struct Activity {
    string name;
    uint price;
    uint capacity;
    uint seatLeft;
  }
  
  struct Student {
    uint id;
    string name;
  }

  mapping (address=>Activity) listofEvents;
  address [] eventsAccts;
  address [] paidPeople;

  function useToken(address actaddress) {
    assert(checkHasPaid(msg.sender) == false);
    assert(EventList(actaddress) == true);
    Activity myAct = listofEvents[actaddress];
    assert(myAct.capacity > myAct.seatLeft);
    paidPeople.push(msg.sender);
    actaddress.transfer(myAct.price);
    --myAct.seatLeft;
  }

  function checkHasPaid(address people) returns (bool) {
    for(uint i = 0; i < paidPeople.length; i++){
      if(paidPeople[i] == people) return true;
      }
    return false;
  }

  function EventList (address events) returns (bool) {
    for(uint i = 0; i < eventsAccts.length; i++){
      if(eventsAccts[i] == events) return true;
    }
  return false;
  }
}
