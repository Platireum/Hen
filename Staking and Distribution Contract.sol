// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./HenToken.sol";

contract HenStaking is Ownable {
    HenToken public henToken;
    
    // User staking information
    struct UserInfo {
        uint256 amount;
        uint256 rewardDebt;
    }
    
    // Total staked amount
    uint256 public totalStaked;
    
    // Reward tracking
    uint256 public rewardPerToken;
    uint256 public lastRewardUpdate;
    
    // User data mapping
    mapping(address => UserInfo) public userInfo;
    
    constructor(address _henToken) {
        henToken = HenToken(_henToken);
        lastRewardUpdate = block.timestamp;
    }
    
    // Update reward calculations
    function updateRewards() public {
        if (block.timestamp <= lastRewardUpdate) return;
        
        uint256 balance = henToken.balanceOf(address(this));
        if (totalStaked > 0 && balance > 0) {
            uint256 timePassed = block.timestamp - lastRewardUpdate;
            uint256 rewardAmount = (balance * timePassed) / 1 days;
            rewardPerToken += (rewardAmount * 1e18) / totalStaked;
        }
        
        lastRewardUpdate = block.timestamp;
    }
    
    // Stake HEN tokens
    function stake(uint256 _amount) external {
        updateRewards();
        
        UserInfo storage user = userInfo[msg.sender];
        if (user.amount > 0) {
            uint256 pending = (user.amount * rewardPerToken) / 1e18 - user.rewardDebt;
            if (pending > 0) {
                safeHenTransfer(msg.sender, pending);
            }
        }
        
        henToken.transferFrom(msg.sender, address(this), _amount);
        user.amount += _amount;
        user.rewardDebt = (user.amount * rewardPerToken) / 1e18;
        totalStaked += _amount;
    }
    
    // Unstake HEN tokens
    function unstake(uint256 _amount) external {
        updateRewards();
        
        UserInfo storage user = userInfo[msg.sender];
        require(user.amount >= _amount, "Insufficient staked amount");
        
        uint256 pending = (user.amount * rewardPerToken) / 1e18 - user.rewardDebt;
        if (pending > 0) {
            safeHenTransfer(msg.sender, pending);
        }
        
        user.amount -= _amount;
        user.rewardDebt = (user.amount * rewardPerToken) / 1e18;
        totalStaked -= _amount;
        
        henToken.transfer(msg.sender, _amount);
    }
    
    // Claim accumulated rewards
    function claimRewards() external {
        updateRewards();
        
        UserInfo storage user = userInfo[msg.sender];
        uint256 pending = (user.amount * rewardPerToken) / 1e18 - user.rewardDebt;
        if (pending > 0) {
            safeHenTransfer(msg.sender, pending);
            user.rewardDebt = (user.amount * rewardPerToken) / 1e18;
        }
    }
    
    // Safe token transfer function
    function safeHenTransfer(address _to, uint256 _amount) internal {
        uint256 henBalance = henToken.balanceOf(address(this));
        if (_amount > henBalance) {
            henToken.transfer(_to, henBalance);
        } else {
            henToken.transfer(_to, _amount);
        }
    }
}