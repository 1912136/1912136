// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AQADIR is ERC20 {
    constructor() ERC20("AQADIR", "AQ") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}

contract STAKING {
    IERC20 token;
    address public owner;
    constructor(IERC20 _token){
        token = _token;
        owner = msg.sender;
    }
    
    modifier onlyOwner(){
        require(owner == msg.sender);
        _;
    }
    mapping(address => uint256) public stakedAmount;
    mapping(address => bool) public isClaimed;

   uint256 public percentage;

   function setPercentage(uint256 _percentage) public onlyOwner{
       percentage = _percentage;
   }

    function stake(uint256 _amount) public {
        require(_amount >= 1, "not enough token");
        require(token.balanceOf(msg.sender) >= 1, "not enough balance");
        token.transferFrom(msg.sender,address(this),_amount);
        stakedAmount[msg.sender] += _amount;
        isClaimed[msg.sender] = false;
    }

    function unstake(uint256 _amount) public {
        require(_amount >=1, "not enough entered");
        require(stakedAmount[msg.sender] >= _amount, "not enoughe balance");
        token.transfer(msg.sender,_amount);
        stakedAmount[msg.sender] -= _amount;
    }

    function claimReward() public {
        require(isClaimed[msg.sender] == false, "you have already claimed");
        require(percentage >= 1, "percentage not set");
        uint256 userStackedAmount = stakedAmount[msg.sender];
        token.transfer(msg.sender,(userStackedAmount /100) * percentage );
        isClaimed[msg.sender] = true;
    }
}