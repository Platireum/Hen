// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Platireum.sol";

/**
 * @title RewardDistributor
 * @dev Manages the distribution of staking rewards to Platireum (HEN) token holders.
 */
contract RewardDistributor is Ownable {
    // The address of the Platireum stablecoin contract.
    Platireum public stablecoin;
    // The address of the developer to receive the 1 per mille fee.
    address public developerAddress;
    
    // A mapping to track the rewards owed to each user.
    mapping(address => uint256) public rewardsOwed;

    // A mapping to track the last time a user's reward was updated.
    mapping(address => uint256) public lastUpdatedRewardTime;

    // A mapping to store the total amount of a reward token received.
    mapping(address => uint256) public totalRewardTokenReceived;

    // A list of supported reward tokens.
    address[] public supportedRewardTokens;
    mapping(address => bool) public isRewardToken;

    // The address of the contract that will send the rewards (CollateralPool).
    address public collateralPoolContract;
    
    // The total supply of stablecoins used for calculating rewards.
    uint256 public totalStablecoinSupply;
    
    // Events for logging.
    event RewardsClaimed(address indexed user, address indexed token, uint256 amount);
    event RewardsReceived(address indexed token, uint256 amount);

    /**
     * @dev Constructor to set the stablecoin address and developer address.
     * @param _stablecoin The address of the Platireum contract.
     * @param _developer The address of the developer.
     */
    constructor(address _stablecoin, address _developer) {
        stablecoin = Platireum(_stablecoin);
        developerAddress = _developer;
    }

    /**
     * @dev Sets the address of the collateral pool contract.
     * This is needed to ensure only the pool can send rewards.
     * @param _collateralPool The address of the CollateralPool contract.
     */
    function setCollateralPoolContract(address _collateralPool) public onlyOwner {
        collateralPoolContract = _collateralPool;
    }

    /**
     * @dev Allows the owner to add a new reward token.
     * @param tokenAddress The address of the new reward token.
     */
    function addRewardToken(address tokenAddress) public onlyOwner {
        require(!isRewardToken[tokenAddress], "Reward token already supported.");
        supportedRewardTokens.push(tokenAddress);
        isRewardToken[tokenAddress] = true;
    }

    /**
     * @dev Function to receive rewards from the CollateralPool.
     * Only callable by the designated collateral pool contract.
     * @param tokenAddress The address of the reward token.
     */
    function receiveRewards(address tokenAddress, uint256 amount) public {
        require(msg.sender == collateralPoolContract, "Only the collateral pool can send rewards.");
        
        // This is a simplified function; a real-world scenario would require
        // a more complex calculation based on timestamps.
        
        // 1 per mille (0.1%) developer fee.
        uint256 developerFee = amount / 1000;
        uint256 rewardAmount = amount - developerFee;

        // Transfer the fee to the developer.
        IERC20(tokenAddress).transfer(developerAddress, developerFee);
        
        // Add the remaining amount to the total rewards.
        totalRewardTokenReceived[tokenAddress] += rewardAmount;
        
        // Note: The actual calculation of "rewards owed" to each user is complex
        // and would be implemented in a separate calculation function.
        // For simplicity, we are just storing the total received amount.
        
        emit RewardsReceived(tokenAddress, amount);
    }
    
    /**
     * @dev Allows a user to claim their rewards manually.
     * @param tokenAddress The address of the reward token to claim.
     */
    function claimRewards(address tokenAddress) public {
        // Here, we would calculate the user's owed rewards
        // and update their record to zero after the transfer.
        uint256 rewardsToClaim = calculateRewards(msg.sender, tokenAddress);
        require(rewardsToClaim > 0, "No rewards to claim.");

        // Transfer the rewards to the user.
        IERC20(tokenAddress).transfer(msg.sender, rewardsToClaim);
        
        // Reset the user's rewards owed.
        rewardsOwed[msg.sender] = 0;
        
        emit RewardsClaimed(msg.sender, tokenAddress, rewardsToClaim);
    }
    
    /**
     * @dev Calculates the rewards owed to a user.
     * This function is a placeholder for a complex formula.
     * @param user The address of the user.
     * @param tokenAddress The address of the reward token.
     */
    function calculateRewards(address user, address tokenAddress) public view returns (uint256) {
        // A complex formula would go here. For example:
        // (stablecoin.balanceOf(user) / stablecoin.totalSupply()) * totalRewardTokenReceived[tokenAddress];
        // For now, this is a placeholder.
        return 0;
    }
}
