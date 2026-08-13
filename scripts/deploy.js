const hre = require("hardhat");

async function main() {
  console.log(`Deploying TodoList to ${hre.network.name}...`);

  const TodoList = await hre.ethers.getContractFactory("TodoList");
  const todoList = await TodoList.deploy();
  await todoList.waitForDeployment();

  const address = await todoList.getAddress();
  console.log(`TodoList deployed to: ${address}`);
  console.log(`View it on the explorer once indexed.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
