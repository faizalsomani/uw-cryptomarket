pragma solidity ^0.4.18;

import './IERC20.sol';
import './SafeMath.sol';

contract WatCoin is IERC20 {
    
    using SafeMath for uint256;
    
    uint public _totalSupply = 0;
    
    string public constant symbol = "We";
    string public constant name = "WatCoin";
    uint8 public constant decimals = 18;
    
    uint256 public constant RATE = 1000;
    
    address public owner;
    
    function WatCoin() {
        //Set owner as creator of contract
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
    
    function mintToken(address target, uint256 mintedAmount) onlyOwner {
        require(mintedAmount > 0);
        balances[target] = balances[target].add(mintedAmount);
        _totalSupply = _totalSupply.add(mintedAmount);
        Transfer(0, owner, mintedAmount);
        Transfer(owner, target, mintedAmount);
    }
    
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    function transfer(address _to, uint256 _value) returns (bool success){
        require(
          balances[msg.sender] > _value && _value > 0
        );
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
        require(
            allowed[_from][msg.sender] >= _value
            && balances[_from] >= _value
            && _value > 0
        );
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) returns (bool success){
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) constant returns (uint256 remaining){
        return allowed[_owner][_spender];
    }
    function burn(uint256 _value) onlyOwner public returns (bool success) {
        require(balances[msg.sender] >= _value);   // Check if the sender has enough
        balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
        _totalSupply = _totalSupply.sub(_value);                      // Updates totalSupply
        Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balances[_from] >= _value);                // Check if the targeted balance is enough
        require(_value <= allowed[_from][msg.sender]);    // Check allowance
        balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
        _totalSupply = _totalSupply.sub(_value);                              // Update totalSupply
        Burn(_from, _value);
        return true;
    }
    
    function totalSupply() constant returns (uint256 totalSupply){
        return _totalSupply;
    }
    function balanceOf(address _owner) constant returns (uint256 balance){
        return balances[_owner];
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed from, uint256 value);
}