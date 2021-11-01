// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";

interface IErc20 {
    function totalSupply() external view returns(uint256);
    function balanceOf(address account) external view returns(uint256);
    function allowance(address owner, address spender) external view returns(uint256);
    function transfer(address recipient, uint256 amount) external returns(bool);
    function approve(address spender, uint256 amount) external returns(bool);
    function transferFrom(address sender, address recepient, uint256 amount) external returns(bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Erc20Basic is IErc20 {
    
    string public constant name = "Sherrycoin";
    string public constant symbol = "SHC";
    uint8 public constant decimals = 18;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    using SafeMath for uint256;
    
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    uint256 totalSupply_;
    
    constructor(uint256 initialSupply) public {
        totalSupply_ = initialSupply;
        balances[msg.sender] = totalSupply_;
    }
    
    function totalSupply() public override view returns(uint256) {
        return totalSupply_;
    }
    
    function increaseTotalSupply(uint amount) public {
        totalSupply_ += amount;
        balances[msg.sender] += amount;
    }
    
    function balanceOf(address account) public override view returns(uint256) {
        return balances[account];
    }
    
    function allowance(address owner, address spender) external override view returns(uint256) {
        return allowed[owner][spender];
    }
    
    function transfer(address recipient, uint256 amount) public override returns(bool) {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[recipient] = balances[recipient].add(amount);
        emit Transfer(msg.sender, recipient, amount);
        
        return true;
    }
    
    function approve(address spender, uint256 amount) public override returns(bool) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        
        return true;
    }
    
    function transferFrom(address sender, address recepient, uint256 amount) public override returns(bool) {
        require(amount <= balances[sender]);
        require(amount <= allowed[sender][msg.sender]);
        
        balances[sender] = balances[sender].sub(amount);
        allowed[sender][msg.sender] = allowed[sender][msg.sender].sub(amount);
        balances[recepient] = balances[recepient].add(amount);
        emit Transfer(sender, recepient, amount);
        
        return true;
    }
}