// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Platireum.sol";

/**
 * @title RewardDistributor
 * @dev Manages the distribution of staking rewards to Platireum (HEN) token holders.
 * This contract handles both manual and automatic reward claims.
 */
contract RewardDistributor is Ownable {
    // The address of the Platireum stablecoin contract.
    Platireum public stablecoin;
    // The address of the developer to receive the 1 per mille fee.
    address public developerAddress;
    
    // A mapping to track the rewards owed to each user for each token.
    mapping(address => mapping(address => uint256)) public rewardsOwed;
    
    // A mapping to store the total amount of a reward token received.
    mapping(address => uint256) public totalRewardTokenReceived;

    // A list of supported reward tokens.
    address[] public supportedRewardTokens;
    mapping(address => bool) public isRewardToken;
    
    // Event to log reward claiming.
    event RewardsClaimed(address indexed user, address indexed token, uint256 amount);
    // Event to log automatic reward distribution.
    event RewardsDistributedAutomatically(address indexed user, address indexed token, uint256 amount);

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
     * @dev Allows the owner to add a new reward token.
     * @param tokenAddress The address of the new reward token.
     */
    function addRewardToken(address tokenAddress) public onlyOwner {
        require(!isRewardToken[tokenAddress], "Reward token already supported.");
        supportedRewardTokens.push(tokenAddress);
        isRewardToken[tokenAddress] = true;
    }

    /**
     * @dev A function to receive rewards from the CollateralPool.
     * This function should only be called by the trusted collateral pool contract.
     * @param tokenAddress The address of the reward token.
     * @param amount The amount of rewards received.
     */
    function receiveRewards(address tokenAddress, uint256 amount) public {
        require(isRewardToken[tokenAddress], "Token is not a supported reward token.");
        
        uint256 developerFee = amount / 1000; // 0.1% developer fee.
        uint256 rewardAmount = amount - developerFee;
        
        // Transfer the fee to the developer.
        IERC20(tokenAddress).transfer(developerAddress, developerFee);
        
        totalRewardTokenReceived[tokenAddress] += rewardAmount;
    }

    /**
     * @dev Allows a user to claim their rewards manually.
     * @param tokenAddress The address of the reward token to claim.
     */
    function claimRewards(address tokenAddress) public {
        uint256 rewardsToClaim = rewardsOwed[msg.sender][tokenAddress];
        require(rewardsToClaim > 0, "No rewards to claim.");

        // Reset the user's rewards owed.
        rewardsOwed[msg.sender][tokenAddress] = 0;
        
        // Transfer the rewards to the user.
        IERC20(tokenAddress).transfer(msg.sender, rewardsToClaim);
        
        emit RewardsClaimed(msg.sender, tokenAddress, rewardsToClaim);
    }
    
    /**
     * @dev This function calculates and sends accrued rewards to the user.
     * It is designed to be called automatically by the Platireum contract
     * whenever a user makes a transaction.
     * @param user The address of the user whose rewards will be distributed.
     * @param tokenAddress The address of the reward token.
     */
    function distributeRewards(address user, address tokenAddress) public {
        // This 'require' statement ensures only trusted contracts (like Platireum) can call this.
        require(msg.sender == address(stablecoin), "Access denied.");
        
        // This is a simplified calculation. A real system would use a more sophisticated formula
        // to calculate a proportional share based on how long the user held the stablecoin.
        // For now, we will assume a simple proportional distribution.
        
        // Calculate the user's share of the total rewards received.
        // This logic would need to be integrated with a global reward index.
        uint256 userShare = (stablecoin.balanceOf(user) * totalRewardTokenReceived[tokenAddress]) / stablecoin.totalSupply();

        // Add the new share to the user's owed rewards.
        rewardsOwed[user][tokenAddress] += userShare;

        // Note: The actual transfer of funds is handled by the claim function.
        // Here, we just update the owed amount. The automatic transfer logic would be in Platireum.
    }
}
