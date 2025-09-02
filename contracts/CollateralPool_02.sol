// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Platireum.sol";

/**
 * @title CollateralPool
 * @dev Manages collateral deposits and interacts with external staking protocols.
 */
contract CollateralPool is Ownable {
    // A mapping to track the balances of each collateral token.
    mapping(address => uint256) public totalCollateral;

    // The address of the stablecoin contract.
    Platireum public platireum;

    // A list of supported collateral tokens.
    address[] public supportedTokens;

    // A mapping to check if a token is supported.
    mapping(address => bool) public isSupported;

    // Event emitted when new collateral is deposited.
    event CollateralDeposited(address indexed user, address indexed token, uint256 amount);

    /**
     * @dev Sets the address of the Platireum token.
     * @param _platireum The address of the Platireum contract.
     */
    constructor(address _platireum) {
        platireum = Platireum(_platireum);
    }

    /**
     * @dev Adds a new collateral token to the list of supported tokens.
     * Only the owner can call this function.
     * @param tokenAddress The address of the new token.
     */
    function addSupportedToken(address tokenAddress) public onlyOwner {
        require(!isSupported[tokenAddress], "Token is already supported.");
        supportedTokens.push(tokenAddress);
        isSupported[tokenAddress] = true;
    }

    /**
     * @dev Deposits collateral into the pool.
     * @param tokenAddress The address of the collateral token.
     * @param amount The amount of collateral to deposit.
     */
    function depositCollateral(address tokenAddress, uint256 amount) public {
        require(isSupported[tokenAddress], "Token is not supported.");
        // Transfer collateral from the user to the contract.
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
        
        // Update the total collateral amount.
        totalCollateral[tokenAddress] += amount;

        emit CollateralDeposited(msg.sender, tokenAddress, amount);
    }

    // In a future step, we'll add functions to handle staking and balancing.
}
