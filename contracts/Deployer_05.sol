// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Platireum.sol";
import "./CollateralPool.sol";
import "./AutomatedBalancer.sol";
import "./RewardDistributor.sol";

contract Deployer {
    address public developerAddress;
    address public priceOracleAddress;
    
    Platireum public platireum;
    CollateralPool public collateralPool;
    AutomatedBalancer public balancer;
    RewardDistributor public rewardDistributor;

    constructor(address _developer, address _priceOracle) {
        developerAddress = _developer;
        priceOracleAddress = _priceOracle;
        
        // Step 1: Deploy Platireum (the stablecoin)
        platireum = new Platireum();
        
        // Step 2: Deploy CollateralPool, passing the Platireum address to its constructor
        collateralPool = new CollateralPool(address(platireum));
        
        // Step 3: Deploy RewardDistributor, passing the Platireum address and developer address
        rewardDistributor = new RewardDistributor(address(platireum), developerAddress);

        // Step 4: Deploy AutomatedBalancer, passing all required addresses
        balancer = new AutomatedBalancer(address(platireum), address(collateralPool), priceOracleAddress);
        
        // Step 5: Final linking
        // The Platireum contract needs to know its balancer.
        platireum.setBalancerContract(address(balancer));
        
        // The CollateralPool needs to know its reward distributor.
        collateralPool.setRewardDistributor(address(rewardDistributor));
    }
}
