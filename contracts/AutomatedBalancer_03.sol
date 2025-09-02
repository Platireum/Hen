// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Platireum.sol";
import "./CollateralPool.sol";

/**
 * @title AutomatedBalancer
 * @dev The contract responsible for monitoring the stablecoin's price and
 * automatically taking actions (minting/burning) to maintain its peg to $1.
 */
contract AutomatedBalancer is Ownable {
    // The target price for the stablecoin (e.g., 1 dollar with 18 decimals).
    uint256 public constant TARGET_PRICE = 1 * 10**18;

    // Contract addresses for the stablecoin, collateral pool, and price oracle.
    Platireum public stablecoin;
    CollateralPool public collateralPool;
    address public priceOracle;

    /**
     * @dev Sets the addresses of the core contracts.
     * @param _stablecoin The address of the Platireum token.
     * @param _collateralPool The address of the CollateralPool.
     * @param _priceOracle The address of the price oracle.
     */
    constructor(address _stablecoin, address _collateralPool, address _priceOracle) {
        stablecoin = Platireum(_stablecoin);
        collateralPool = CollateralPool(_collateralPool);
        priceOracle = _priceOracle;
        
        // The balancer contract must be the owner of the Platireum contract to mint.
        stablecoin.setBalancerContract(address(this));
    }

    /**
     * @dev Sets the price oracle address.
     * @param _priceOracle The address of the new price oracle.
     */
    function setPriceOracle(address _priceOracle) public onlyOwner {
        priceOracle = _priceOracle;
    }
    
    /**
     * @dev The main rebalancing function. It can be triggered by a bot or owner.
     * In a real-world scenario, this function would be triggered automatically
     * by a service like Chainlink Keepers or a dedicated bot.
     */
    function rebalance() public onlyOwner {
        // Placeholder for fetching the price from the oracle.
        // In a real-world application, this would use a secure oracle protocol like Chainlink.
        uint256 currentPrice = getPriceFromOracle();

        if (currentPrice > TARGET_PRICE) {
            // Price is too high. Increase supply by issuing more stablecoins.
            // This is a simplified action. A real system would have a more complex algorithm.
            // For example: incentivize users to deposit collateral to mint new tokens.
        } else if (currentPrice < TARGET_PRICE) {
            // Price is too low. Decrease supply by burning stablecoins.
            // A real system would use its balancing collateral to buy back tokens from the market and burn them.
            // This requires interaction with a DEX.
        }
    }
    
    /**
     * @dev Issues new stablecoins to a user in exchange for collateral.
     * The user must first approve the collateralPool to spend their tokens.
     * @param tokenAddress The address of the collateral token.
     * @param collateralAmount The amount of collateral to deposit.
     * @param stablecoinAmount The amount of stablecoins to mint.
     */
    function issueStablecoins(address tokenAddress, uint256 collateralAmount, uint256 stablecoinAmount) public {
        // Transfer collateral from the user to the collateral pool.
        IERC20(tokenAddress).transferFrom(msg.sender, address(collateralPool), collateralAmount);
        
        // Use a function in the collateral pool to track the new deposit.
        // This part needs a slight adjustment in the CollateralPool contract to be callable externally.
        collateralPool.depositCollateral(tokenAddress, collateralAmount);
        
        // Mint stablecoins and send them to the user.
        stablecoin.mint(msg.sender, stablecoinAmount);
    }
    
    // Placeholder function to get the price from the oracle.
    function getPriceFromOracle() private view returns (uint256) {
        // This is a simplified function. A real oracle would be called here.
        return 1 * 10**18; 
    }
}
