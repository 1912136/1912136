// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
       _mint(msg.sender, 1000); 
    }
}


contract sale{
    IERC20 public token;
    uint256 price = 1000;
    uint256 public numOfToken;

    constructor(IERC20 _token){
        token = IERC20(_token);
    }

    function buy() public payable{
        numOfToken = msg.value * price;
        token.transfer(msg.sender, numOfToken);
    }

    function sell() public{
        token.transfer(address(this), numOfToken);
        payable(msg.sender).transfer(address(this).balance);
    }
}