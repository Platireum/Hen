# HEN STABLECOIN WHITEPAPER

1. INTRODUCTION

---

HEN is a smart stablecoin pegged to the US Dollar (1 HEN = 1 USD) with integrated staking rewards. Unlike traditional stablecoins like USDT and DAI, HEN automatically distributes daily profits to holders through its unique staking mechanism.

2. CORE CONCEPT

---

Key Features:

- Stable 1:1 USD peg
- Cross-chain compatibility
- Daily reward distribution
- Non-custodial design

Value Proposition:
"Golden-egg-laying hen" model:

- Preserves capital (stable value)
- Generates daily yield (staking rewards)

3. SYSTEM ARCHITECTURE

---

3.1 HEN TOKEN (ERC-20)

- Network: Ethereum/BSC/Polygon
- Functions:

  - Balance tracking
  - Peg maintenance
  - Reward distribution

  3.2 STABILIZATION CONTRACT

- Collateral types: ETH, BTC, USDC
- Peg mechanism:

  1. Users deposit crypto collateral
  2. System mints HEN tokens
  3. 110% minimum collateral ratio
  4. Oracle price feeds (Chainlink)

  3.3 STAKING POOL

- Yield sources:
  - ETH 2.0 staking
  - DeFi protocol rewards
- Features:
  - Auto-compounding
  - Daily distributions
  - No lock-up period

4. REWARD MECHANICS

---

Reward Flow:

1. Staking generates yields
2. Yields converted to USD value
3. Distributed proportionally to holders

Example Calculation:

- Total supply: 1,000,000 HEN
- Your balance: 10,000 HEN (1%)
- Daily rewards pool: $1,000
- Your daily reward: $10 (1%)

5. COMPARATIVE ANALYSIS

---

| FEATURE          | USDT/DAI       | HEN            |
| ---------------- | -------------- | -------------- |
| Peg Mechanism    | Centralized    | Decentralized  |
| Yield Generation | No             | Yes (1% daily) |
| Collateral       | Fiat reserves  | Crypto assets  |
| Accessibility    | TradFi bridges | Native Web3    |

6. BENEFITS

---

For Users:

- Stable store of value
- Passive income generation
- No minimum stake requirements
- Full asset control

For Ecosystem:

- Increased token utility
- Sustainable yield model
- Cross-chain compatibility

7. CHALLENGES & MITIGATION

---

| Challenge              | Solution               |
| ---------------------- | ---------------------- |
| Oracle risks           | Multi-source feeds     |
| Collateral volatility  | Over-collateralization |
| Regulatory uncertainty | Transparent operations |

8. CONCLUSION

---

HEN represents next-generation stablecoin design combining:

- Price stability of fiat pegs
- Yield potential of DeFi
- Accessibility of Web3

Projected Impact:

- Daily rewards for holders
- Sustainable yield model
- Mainstream adoption bridge

## CONTACT INFORMATION

Website: www.platireum.com
Whitepaper: docs.platireum.com
Email: contact@platireum.com

# Hen Token Ecosystem

## Overview

The Hen Token Ecosystem consists of three main contracts:

1. **HenToken (ERC-20)** - The main token contract with stablecoin functionality
2. **HenStabilizer** - Contract responsible for price stabilization
3. **HenStaking** - Contract for staking and reward distribution

## Prerequisites

- Node.js and npm installed
- An Ethereum wallet with ETH for deployment
- Infura or Alchemy API key (for testnet/mainnet deployments)
- Etherscan API key (for contract verification)

## Setup

1. Clone the repository
2. Install dependencies:

```
npm install
```

3. Create a `.env` file in the root directory with the following content:

```
# Network RPC URLs
MAINNET_RPC_URL=https://mainnet.infura.io/v3/your-api-key
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/your-api-key

# Private key for deployment (DO NOT COMMIT WITH REAL KEY)
PRIVATE_KEY=your-ethereum-private-key

# API keys for verification
ETHERSCAN_API_KEY=your-etherscan-api-key

# Contract initialization parameters
INITIAL_SUPPLY=1000000000000000000000000
```

## Compilation

Compile the contracts:

```
npm run compile
```

## Testing

Run the tests:

```
npm run test
```

## Deployment

### Local Deployment (Development)

To deploy on a local Hardhat node:

```
npm run deploy:local
```

This will:

1. Start a local Hardhat node
2. Deploy all three contracts
3. Link the contracts together
4. Save the contract addresses to your `.env` file

### Testnet Deployment (Sepolia)

To deploy on Sepolia testnet:

```
npm run deploy:testnet
```

Make sure your `.env` file has:

- `SEPOLIA_RPC_URL`: Your Sepolia RPC URL
- `PRIVATE_KEY`: Your wallet's private key with Sepolia ETH
- `INITIAL_SUPPLY`: Initial token supply

### Mainnet Deployment

To deploy on Ethereum mainnet:

```
npm run deploy:mainnet
```

**IMPORTANT**: This will use real ETH for gas fees. Make sure your `.env` file has:

- `MAINNET_RPC_URL`: Your Ethereum mainnet RPC URL
- `PRIVATE_KEY`: Your wallet's private key with mainnet ETH
- `INITIAL_SUPPLY`: Initial token supply

You will be prompted to confirm the deployment.

## Contract Verification

After deployment, you can verify the contracts on Etherscan:

```
npm run verify
```

Make sure your `.env` file contains:

- `ETHERSCAN_API_KEY`: Your Etherscan API key
- `HEN_TOKEN_ADDRESS`: Deployed HenToken address
- `HEN_STABILIZER_ADDRESS`: Deployed HenStabilizer address
- `HEN_STAKING_ADDRESS`: Deployed HenStaking address

## Contract Interaction

After deployment, you will need to:

1. Fund the stabilization contract with collateral
2. Set appropriate distribution rates in the HenToken contract
3. Monitor and adjust the contracts as needed for price stability

## License

MIT
