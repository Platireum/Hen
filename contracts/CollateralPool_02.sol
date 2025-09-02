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

    // Mapping to store the address of the liquid staking protocol for each token.
    mapping(address => address) public liquidStakingProtocols;

    // A mapping to track the amount of each token that has been staked externally.
    mapping(address => uint256) public stakedAmounts;
    
    // Address of the RewardDistributor contract
    address public rewardDistributor;

    // Event emitted when new collateral is deposited.
    event CollateralDeposited(address indexed user, address indexed token, uint256 amount);

    // Event emitted when collateral is staked.
    event CollateralStaked(address indexed token, uint256 amount);
    
    // Event emitted when collateral is unstaked.
    event CollateralUnstaked(address indexed token, uint256 amount);
    
    // Event emitted when rewards are collected and sent to the distributor.
    event RewardsSentToDistributor(address indexed token, uint256 amount);

    /**
     * @dev Sets the address of the Platireum token.
     * @param _platireum The address of the Platireum contract.
     */
    constructor(address _platireum) {
        platireum = Platireum(_platireum);
    }
    
    /**
     * @dev Sets the address of the RewardDistributor contract.
     * @param _distributor The address of the RewardDistributor contract.
     */
    function setRewardDistributor(address _distributor) public onlyOwner {
        rewardDistributor = _distributor;
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
     * @dev Sets the address of the liquid staking protocol for a supported token.
     * Only the owner can call this function.
     * @param tokenAddress The address of the collateral token.
     * @param protocolAddress The address of the staking protocol contract.
     */
    function setLiquidStakingProtocol(address tokenAddress, address protocolAddress) public onlyOwner {
        require(isSupported[tokenAddress], "Token is not supported.");
        liquidStakingProtocols[tokenAddress] = protocolAddress;
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

    /**
     * @dev Stakes a portion of the collateral by sending it to a liquid staking protocol.
     * This function would be called by the AutomatedBalancer.
     * @param tokenAddress The address of the collateral token.
     * @param amount The amount of collateral to stake.
     */
    function stakeCollateral(address tokenAddress, uint256 amount) public onlyOwner {
        require(liquidStakingProtocols[tokenAddress] != address(0), "No liquid staking protocol set for this token.");
        require(totalCollateral[tokenAddress] - stakedAmounts[tokenAddress] >= amount, "Insufficient collateral for staking.");

        // Approve and transfer tokens to the staking protocol.
        IERC20(tokenAddress).approve(liquidStakingProtocols[tokenAddress], amount);
        
        // The actual staking call to the external protocol would go here.
        // For example:
        // IERC20(tokenAddress).transfer(liquidStakingProtocols[tokenAddress], amount);
        
        stakedAmounts[tokenAddress] += amount;
        emit CollateralStaked(tokenAddress, amount);
    }

    /**
     * @dev Unstakes collateral and returns it to the pool.
     * This function would be called by the AutomatedBalancer.
     * @param tokenAddress The address of the collateral token.
     * @param amount The amount of collateral to unstake.
     */
    function unstakeCollateral(address tokenAddress, uint256 amount) public onlyOwner {
        require(liquidStakingProtocols[tokenAddress] != address(0), "No liquid staking protocol set for this token.");
        require(stakedAmounts[tokenAddress] >= amount, "Insufficient staked amount.");
        
        // The actual unstaking logic would depend on the specific protocol (e.g., calling an `unstake` function).
        // For example: IERC20(liquidStakingToken).transferFrom(stakingProtocol, address(this), amount);
        
        stakedAmounts[tokenAddress] -= amount;
        emit CollateralUnstaked(tokenAddress, amount);
    }
    
    /**
     * @dev Collects rewards from the liquid staking protocol and sends them to the RewardDistributor.
     * This function can be called by an external bot or the owner to trigger reward collection.
     * @param tokenAddress The address of the reward token to collect.
     */
    function collectAndSendRewards(address tokenAddress) public onlyOwner {
        // Here, we would interact with the staking protocol to withdraw rewards.
        // Example: IERC20(rewardToken).transferFrom(stakingProtocol, address(this), amount);
        
        uint256 rewardAmount = IERC20(tokenAddress).balanceOf(address(this));
        
        require(rewardAmount > 0, "No rewards to send.");
        
        // Send the collected rewards to the distributor contract.
        IERC20(tokenAddress).transfer(rewardDistributor, rewardAmount);
        
        emit RewardsSentToDistributor(tokenAddress, rewardAmount);
    }

    /**
     * @dev Returns the amount of collateral available for balancing (not staked).
     * @param tokenAddress The address of the collateral token.
     * @return The amount of available collateral.
     */
    function getAvailableCollateral(address tokenAddress) public view returns (uint256) {
        return totalCollateral[tokenAddress] - stakedAmounts[tokenAddress];
    }
}
