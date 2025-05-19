// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HenToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("Hen Stablecoin", "HEN") {
        _mint(msg.sender, initialSupply);
    }

    // Function to get all token holders and their balances
    // ISSUE #1: This approach might be inefficient and gas-costly if the number of holders is very large.
    // A more scalable solution might be needed, such as maintaining a separate mapping of holders.
    function getAllTokenHolders() external view onlyOwner returns (address[] memory, uint256[] memory) {
        uint256 totalSupply = _totalSupply;
        address[] memory holders = new address[](totalSupply);
        uint256[] memory balances = new uint256[](totalSupply);
        uint256 index = 0;
        for (uint256 i = 0; i < totalSupply; i++) {
            // ISSUE #2: There's no direct way to iterate through all token holders in ERC-20.
            // This would require maintaining a separate data structure of holders upon each transfer/mint/burn.
            // This implementation is a placeholder and won't work as intended.
            // A proper solution needs to track holders explicitly.
        }
        return (holders, balances);
    }
}
