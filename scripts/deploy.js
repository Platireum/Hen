// Deployment script for Hen Token ecosystem
const hre = require("hardhat");
require("dotenv").config();
const fs = require("fs");
const path = require("path");

async function main() {
  console.log("Deploying Hen Token ecosystem...");

  // Get the contract factories
  const HenToken = await hre.ethers.getContractFactory("HenToken");
  const HenStabilizer = await hre.ethers.getContractFactory("HenStabilizer");
  const HenStaking = await hre.ethers.getContractFactory("HenStaking");

  // Get deployment parameters from environment variables or use defaults
  const initialSupply =
    process.env.INITIAL_SUPPLY || "1000000000000000000000000"; // 1 million tokens with 18 decimals

  // Deploy HenToken contract
  console.log("Deploying HenToken...");
  const henToken = await HenToken.deploy(initialSupply);
  await henToken.waitForDeployment();
  const henTokenAddress = await henToken.getAddress();
  console.log(`HenToken deployed to: ${henTokenAddress}`);

  // Deploy HenStabilizer contract
  console.log("Deploying HenStabilizer...");
  const henStabilizer = await HenStabilizer.deploy(henTokenAddress);
  await henStabilizer.waitForDeployment();
  const henStabilizerAddress = await henStabilizer.getAddress();
  console.log(`HenStabilizer deployed to: ${henStabilizerAddress}`);

  // Deploy HenStaking contract
  console.log("Deploying HenStaking...");
  const henStaking = await HenStaking.deploy(henTokenAddress);
  await henStaking.waitForDeployment();
  const henStakingAddress = await henStaking.getAddress();
  console.log(`HenStaking deployed to: ${henStakingAddress}`);

  // Configure contracts
  console.log("Configuring contract relationships...");

  // Set stabilizer and staking contracts in HenToken
  const setStabilizerTx = await henToken.setStabilizerContract(
    henStabilizerAddress
  );
  await setStabilizerTx.wait();
  console.log("Set stabilizer contract in HenToken");

  const setStakingTx = await henToken.setStakingContract(henStakingAddress);
  await setStakingTx.wait();
  console.log("Set staking contract in HenToken");

  // Save deployed addresses to .env file
  await saveAddressesToEnv(
    henTokenAddress,
    henStabilizerAddress,
    henStakingAddress
  );

  console.log("Deployment completed successfully!");

  // Return deployed contract addresses
  return {
    HenToken: henTokenAddress,
    HenStabilizer: henStabilizerAddress,
    HenStaking: henStakingAddress,
  };
}

async function saveAddressesToEnv(
  henTokenAddress,
  henStabilizerAddress,
  henStakingAddress
) {
  console.log("Saving contract addresses to .env file...");

  // Read current .env file or create if not exists
  const envPath = path.join(__dirname, "../.env");
  let envContent = "";

  try {
    if (fs.existsSync(envPath)) {
      envContent = fs.readFileSync(envPath, "utf8");
    }
  } catch (error) {
    console.log("Creating new .env file");
  }

  // Replace or add contract addresses
  const envLines = envContent.split("\n");
  const newEnvLines = [];
  let hasTokenAddress = false;
  let hasStabilizerAddress = false;
  let hasStakingAddress = false;

  for (const line of envLines) {
    if (line.startsWith("HEN_TOKEN_ADDRESS=")) {
      newEnvLines.push(`HEN_TOKEN_ADDRESS=${henTokenAddress}`);
      hasTokenAddress = true;
    } else if (line.startsWith("HEN_STABILIZER_ADDRESS=")) {
      newEnvLines.push(`HEN_STABILIZER_ADDRESS=${henStabilizerAddress}`);
      hasStabilizerAddress = true;
    } else if (line.startsWith("HEN_STAKING_ADDRESS=")) {
      newEnvLines.push(`HEN_STAKING_ADDRESS=${henStakingAddress}`);
      hasStakingAddress = true;
    } else if (line.trim() !== "") {
      newEnvLines.push(line);
    }
  }

  // Add missing addresses
  if (!hasTokenAddress) {
    newEnvLines.push(`HEN_TOKEN_ADDRESS=${henTokenAddress}`);
  }
  if (!hasStabilizerAddress) {
    newEnvLines.push(`HEN_STABILIZER_ADDRESS=${henStabilizerAddress}`);
  }
  if (!hasStakingAddress) {
    newEnvLines.push(`HEN_STAKING_ADDRESS=${henStakingAddress}`);
  }

  // Write updated .env file
  fs.writeFileSync(envPath, newEnvLines.join("\n") + "\n");
  console.log("Contract addresses saved to .env file successfully!");
}

// Execute the deployment
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
