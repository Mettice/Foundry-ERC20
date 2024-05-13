# Foundry-ERC20

# Foundry ERC20 Token Project

This repository contains a Solidity project for creating and testing an ERC20 token using Foundry. The project includes:
- **ERC20 Token Contract**: A custom implementation of an ERC20 token with minting and burning capabilities.
- **Manual Token Contract**: A simple token contract for demonstration purposes.
- **Deployment Script**: Automated deployment scripts for deploying the token contract.
- **Comprehensive Tests**: A robust suite of tests covering key functionalities like token transfers, allowances, minting, and burning, implemented with Foundry.
- **Code Coverage Analysis**: Detailed coverage metrics to ensure high code quality and test coverage.

## Features
- ERC20 Token with minting and burning capabilities.
- Manual Token with basic transfer functionality.
- Automated deployment and testing using Foundry.
- High test coverage with detailed metrics.

## Usage
1. **Compilation**:
 
   forge build


Run Tests:

forge test
Run Coverage:


forge coverage
Deployment:


forge script script/DeployOurToken.s.sol --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> 

Repository Structure
src/: Contains the Solidity smart contracts.
OurToken.sol: Main ERC20 token contract.
ManualToken.sol: Simple manual token contract.
script/: Deployment scripts.
DeployOurToken.s.sol: Script for deploying the ERC20 token contract.
test/: Test files.
OurTokenTest.t.sol: Test suite for the ERC20 token.
ManualTokenTest.t.sol: Test suite for the manual token.

Getting Started
Clone the repository:

git clone https://github.com/Mettice/foundry-erc20.git
Navigate to the project directory:

cd foundry-erc20
Install dependencies and set up the project.
Technologies Used
Solidity
Foundry
OpenZeppelin Contracts
