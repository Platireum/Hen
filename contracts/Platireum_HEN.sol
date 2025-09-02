// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Platireum
 * @dev The core stablecoin contract. It is an ERC-20 token with minting and burning controlled
 * by a designated balancer contract.
 */
contract Platireum is ERC20, Ownable {
    // The address of the contract responsible for minting and burning tokens for price stabilization.
    address public balancerContract;

    /**
     * @dev Sets the name and symbol for the token.
     */
    constructor() ERC20("platireum", "HEN") {}

    /**
     * @dev A function to set the address of the balancer contract.
     * This function can only be called by the owner of the contract.
     * @param _balancer The address of the new balancer contract.
     */
    function setBalancerContract(address _balancer) public onlyOwner {
        balancerContract = _balancer;
    }

    /**
     * @dev Mints new tokens and assigns them to an address.
     * This function can only be called by the designated balancer contract.
     * @param to The address to receive the new tokens.
     * @param amount The number of tokens to mint.
     */
    function mint(address to, uint256 amount) public {
        require(msg.sender == balancerContract, "Only the balancer contract can mint.");
        _mint(to, amount);
    }

    /**
     * @dev Burns a specified amount of tokens from the sender's address.
     * This function allows any token holder to burn their own tokens.
     * @param amount The number of tokens to burn.
     */
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}
