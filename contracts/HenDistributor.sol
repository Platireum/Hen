// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./HenToken.sol"; // Assuming HenToken.sol is in the same directory

contract HenDistributor is Ownable {
    HenToken public henToken;
    address public stakingManagerContract;

    constructor(address _henToken) {
        henToken = HenToken(_henToken);
    }

    function setStakingManagerContract(address _stakingManager) external onlyOwner {
        stakingManagerContract = _stakingManager;
    }

    // Function to distribute rewards to HEN token holders
    // ISSUE #10: Distributing rewards in different currencies to all HEN holders proportionally
    // can be gas-intensive, especially with a large number of holders and multiple reward currencies.
    // Performing a direct transfer to each holder for each reward currency in a single transaction is likely infeasible due to gas limits.
    // Solutions might involve:
    // 1. Distributing rewards in batches.
    // 2. Using a Merkle tree airdrop mechanism to reduce gas costs per recipient.
    // 3. Converting all rewards to a single currency (e.g., HEN or a stablecoin) before distribution.
    // 4. Allowing users to claim their rewards.
    function distributeRewards(address _rewardCurrency, uint256 _totalRewardAmount) external onlyOwner {
        require(stakingManagerContract != address(0), "Staking Manager contract not set");

        (address[] memory holders, uint256[] memory balances) = henToken.getAllTokenHolders();
        uint256 totalHenSupply = henToken.totalSupply();

        // ISSUE #11: The getAllTokenHolders() function in HenToken currently has implementation issues.
        // A reliable way to get all token holders and their balances is needed here.

        for (uint256 i = 0; i < holders.length; i++) {
            address holder = holders[i];
            uint256 henBalance = balances[i];
            if (henBalance > 0) {
                // Calculate the reward amount for the holder proportionally
                uint256 rewardAmount = (henBalance * _totalRewardAmount) / totalHenSupply;

                // ISSUE #12: Need to handle the actual transfer of the '_rewardCurrency' to the 'holder'.
                // This contract needs to be able to transfer different tokens.
                // Consider using a safe transfer library or a generic token transfer function.
                // Also, gas costs for each transfer need to be accounted for.
                // Placeholder for actual reward transfer
            }
        }
        // ISSUE #13: Logic to deduct gas costs from the total reward amount needs to be implemented.
        // This might involve tracking gas used per distribution and adjusting future distributions.
    }

    // Owner can manually trigger reward distribution in emergency
    function manualDistributeRewards(address _rewardCurrency, uint256 _totalRewardAmount, address[] memory _recipients, uint256[] memory _amounts) external onlyOwner {
        require(_recipients.length == _amounts.length, "Recipients and amounts length mismatch");
        for (uint256 i = 0; i < _recipients.length; i++) {
            // Placeholder for manual reward transfer
        }
    }
}
