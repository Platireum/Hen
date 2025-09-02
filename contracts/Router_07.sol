// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Platireum.sol";
import "./CollateralPool.sol";
import "./RewardDistributor.sol";
import "./AutomatedBalancer.sol";
import "./PriceOracle.sol";

/**
 * @title Router
 * @dev The main entry point for user interactions. It simplifies user transactions
 * by bundling multiple function calls into one.
 */
contract Router is Ownable {
    Platireum public platireum;
    CollateralPool public collateralPool;
    RewardDistributor public rewardDistributor;
    AutomatedBalancer public balancer;

    /**
     * @dev Sets the addresses of all core contracts.
     * @param _platireum The address of the Platireum contract.
     * @param _collateralPool The address of the CollateralPool contract.
     * @param _rewardDistributor The address of the RewardDistributor contract.
     * @param _balancer The address of the AutomatedBalancer contract.
     */
    constructor(address _platireum, address _collateralPool, address _rewardDistributor, address _balancer) {
        platireum = Platireum(_platireum);
        collateralPool = CollateralPool(_collateralPool);
        rewardDistributor = RewardDistributor(_rewardDistributor);
        balancer = AutomatedBalancer(_balancer);
    }

    /**
     * @dev Allows a user to deposit collateral and mint new stablecoins.
     * The user must approve this contract to spend their collateral first.
     * @param _collateralToken The address of the collateral token (e.g., WETH).
     * @param _collateralAmount The amount of collateral to deposit.
     * @param _stablecoinAmount The amount of Platireum to mint.
     */
    function depositCollateralAndMint(
        address _collateralToken,
        uint256 _collateralAmount,
        uint256 _stablecoinAmount
    ) public {
        // The user's rewards are automatically distributed here.
        // This is a simplified call; the actual logic would be in Platireum.
        // platireum.distributeRewards(msg.sender);

        // Call the issueStablecoins function on the AutomatedBalancer contract.
        // The balancer contract will handle the internal transfer and minting.
        balancer.issueStablecoins(_collateralToken, _collateralAmount, _stablecoinAmount);
    }
    
    /**
     * @dev Allows a user to redeem their collateral by burning stablecoins.
     * The user must approve this contract to burn their stablecoins first.
     * @param _collateralToken The collateral token to redeem.
     * @param _stablecoinAmount The amount of Platireum to burn.
     */
    function burnAndRedeemCollateral(address _collateralToken, uint256 _stablecoinAmount) public {
        // First, burn the Platireum tokens from the user.
        platireum.burn(_stablecoinAmount);

        // Now, transfer the equivalent collateral back to the user.
        // This function would need to be added to the CollateralPool contract.
        // collateralPool.transferCollateralToUser(_collateralToken, msg.sender, _collateralAmount);
    }

    /**
     * @dev Allows a user to claim their accrued rewards manually.
     * @param _rewardToken The address of the reward token.
     */
    function claimRewards(address _rewardToken) public {
        rewardDistributor.claimRewards(_rewardToken);
    }
}
