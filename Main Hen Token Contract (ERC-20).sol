// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HenToken is ERC20, Ownable {
    // Contract responsible for price stabilization
    address public stabilizerContract;
    
    // Contract responsible for staking
    address public stakingContract;
    
    // Daily distribution rate (in basis points)
    uint256 public dailyDistributionRate = 100; // 1% example (adjust as needed)
    
    // Last distribution timestamp
    uint256 public lastDistributionDate;
    
    constructor(uint256 initialSupply) ERC20("Hen Stablecoin", "HEN") {
        _mint(msg.sender, initialSupply);
        lastDistributionDate = block.timestamp;
    }
    
    // Set the stabilizer contract address
    function setStabilizerContract(address _stabilizer) external onlyOwner {
        stabilizerContract = _stabilizer;
    }
    
    // Set the staking contract address
    function setStakingContract(address _staking) external onlyOwner {
        stakingContract = _staking;
    }
    
    // Adjust the distribution rate
    function setDistributionRate(uint256 _rate) external onlyOwner {
        dailyDistributionRate = _rate;
    }
    
    // Internal function to distribute rewards
    function _distributeRewards() internal {
        require(stakingContract != address(0), "Staking contract not set");
        
        uint256 currentTime = block.timestamp;
        if (currentTime - lastDistributionDate >= 1 days) {
            uint256 daysPassed = (currentTime - lastDistributionDate) / 1 days;
            
            // Calculate rewards based on days passed
            uint256 totalRewards = (totalSupply() * dailyDistributionRate * daysPassed) / 10000;
            
            // Transfer rewards to staking contract
            _mint(stakingContract, totalRewards);
            
            lastDistributionDate = currentTime;
        }
    }
    
    // Override transfer functions to include reward distribution
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _distributeRewards();
        return super.transfer(recipient, amount);
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _distributeRewards();
        return super.transferFrom(sender, recipient, amount);
    }
}