// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title PriceOracle
 * @dev A simplified price oracle to provide off-chain price data to other contracts.
 * In a real-world scenario, this contract would integrate with a decentralized oracle network.
 */
contract PriceOracle is Ownable {
    // A variable to store the current price. It is public so other contracts can read it.
    // The price is represented with 18 decimal places. For example, $1 would be 1e18.
    uint256 public latestPrice;

    // Event to log price updates.
    event PriceUpdated(uint256 newPrice);

    /**
     * @dev A function to update the price.
     * This function can only be called by the owner of the contract.
     * @param _newPrice The new price to be set.
     */
    function updatePrice(uint256 _newPrice) public onlyOwner {
        latestPrice = _newPrice;
        emit PriceUpdated(_newPrice);
    }

    /**
     * @dev Returns the latest price stored in the contract.
     * @return The latest price.
     */
    function getLatestPrice() public view returns (uint256) {
        return latestPrice;
    }
}
