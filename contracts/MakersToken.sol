pragma solidity ^0.4.8;

contract owned {
  address public owner;

  function owned() {
    owner = msg.sender;
  }

  modifier onlyOwner {
    if (msg.sender != owner) throw;
    _;
  }

  function transferOwnership(address newOwner) onlyOwner {
    owner = newOwner;
  }

}


contract MakersToken is owned {

  uint256 public totalSupply;
  string public name;
  string public symbol;
  uint8 public decimals;

  mapping (address => uint256) public BalanceOf;
  mapping (address => bool) public frozenAccount;

  event Transfer(address indexed from, address indexed to, uint256 value);
  event FrozenFunds(address target, bool frozen);

  function MakersToken(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol, address centralMinter) {
    if( centralMinter != 0 ) owner = centralMinter;
    totalSupply = initialSupply;
    BalanceOf[msg.sender] = initialSupply;
    name = tokenName;
    symbol = tokenSymbol;
    decimals = decimalUnits;
  }

  function transfer(address _to, uint256 _value) {
    if (frozenAccount[msg.sender]) throw;
    if (BalanceOf[msg.sender] < _value || BalanceOf[_to] + _value < BalanceOf[_to])
      throw;

    BalanceOf[msg.sender] -= _value;
    BalanceOf[_to] += _value;
    Transfer(msg.sender, _to, _value);
  }

  function getBalance() returns (uint) {
    return BalanceOf[msg.sender];
  }

  function mintToken(address target, uint256 mintedAmount) onlyOwner {
    BalanceOf[target] += mintedAmount;
    totalSupply += mintedAmount;
    Transfer(0, owner, mintedAmount);
    Transfer(owner, target, mintedAmount);
  }

  function freezeAccount(address target, bool freeze) onlyOwner {
    frozenAccount[target] = freeze;
    FrozenFunds(target, freeze);
  }

}