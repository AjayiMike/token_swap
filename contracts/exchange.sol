//SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
contract Exchange {
    IERC20 tokenA;
    IERC20 tokenB;
    uint256 exchangeRate;
    address owner;

    constructor(address tokeAAddress_, address tokenBAddress_, uint256 exchangeRate_) {
        tokenA = IERC20(tokeAAddress_);
        tokenB = IERC20(tokenBAddress_);
        exchangeRate = exchangeRate_;
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    function swaptokenAfortokenB(uint256 _amount) public {
        // we first check to see if this contract have enough amount of tokenB be to give user for their tokenA
        uint256 thisContractTokenBBalance = tokenB.balanceOf(address(this));
        require(thisContractTokenBBalance >= (_amount * exchangeRate), "No enough tokenB to swap for this amount of tokeA");

        //this will only work if user have enough amount of tokenA and has granted this contract enough allowance to complete the swap
        tokenA.transferFrom(msg.sender, address(this), _amount);
        //transfering tokenB to user using the exchange rate
        tokenB.transfer(msg.sender, _amount * exchangeRate);
    }

    function changeExchangeRate(uint256 _newRate) public onlyOwner {
        exchangeRate = _newRate;
    }
}