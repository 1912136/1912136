// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
       _mint(msg.sender, 1000); 
    }
}

contract Timelock{
    IERC20 public token;
    uint256 public lockTime;
    address public owner;

    constructor(IERC20 _token){
        token = IERC20(_token);
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(owner == msg.sender, "You are not an owner!");
        _;
    }

    function lock(uint256 _time) public onlyOwner{
        lockTime = _time;
        token.transferFrom(msg.sender, address(this), token.balanceOf(msg.sender));
    }

    function withdraw() public onlyOwner{
        require(block.timestamp > lockTime, "Time not reach!");
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

}