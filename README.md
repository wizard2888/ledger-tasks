# Ledger — an on-chain to-do list on BOT Chain

A minimal dApp: a Solidity contract that stores each wallet's tasks on-chain,
plus a single-page frontend to add, complete, and delete them via MetaMask.

Everything below assumes **zero prior blockchain dev experience**. Follow it top to bottom.

## What you're building

- `contracts/TodoList.sol` — the smart contract that stores tasks
- `scripts/deploy.js` — deploys it to BOT Chain
- `frontend/index.html` — a webpage that connects a wallet and talks to the contract

## 0. Install prerequisites

You need [Node.js](https://nodejs.org) (v18 or later) and the [MetaMask](https://metamask.io)
browser extension installed. Check Node is installed:

```bash
node -v
```

## 1. Install project dependencies

From inside this `todo-dapp` folder:

```bash
npm install
```

This pulls in Hardhat (the tool used to compile, test, and deploy Solidity contracts).

## 2. Create a test wallet and get testnet BOT

**Do not use a wallet that holds real funds for this.** Create a fresh one just for testing:

1. Open MetaMask → click the account icon → "Add account" → "Add a new Bitcoin account"... actually just "Add account or hardware wallet" → "New account". Name it something like "BOT Testnet".
2. Export its private key: Account details → Show private key. Copy it.
3. Copy `.env.example` to `.env` and paste the key in:
   ```bash
   cp .env.example .env
   ```
   Then edit `.env` and set `PRIVATE_KEY=` to the key you copied (no quotes, no `0x` needed either way — both work).
4. Get free testnet BOT from the faucet: https://faucet.botchain.ai/basic
   You'll need your new wallet's **address** (not the private key) for this — copy it from MetaMask.

## 3. Compile the contract

```bash
npm run compile
```

This checks the Solidity code is valid and generates the files Hardhat needs to deploy it.

## 4. Deploy to BOT Chain testnet

```bash
npm run deploy:testnet
```

You'll see output like:

```
Deploying TodoList to botTestnet...
TodoList deployed to: 0xABC123...
```

**Copy that address.** You'll need it in the next step. You can also paste it into
https://scan.bohr.life/ to see your deployed contract on the explorer.

## 5. Connect the frontend to your contract

Open `frontend/index.html` in a text editor and find this line near the top of the `<script>`:

```js
const CONTRACT_ADDRESS = "PASTE_YOUR_DEPLOYED_CONTRACT_ADDRESS_HERE";
```

Replace it with the address from step 4, e.g.:

```js
const CONTRACT_ADDRESS = "0xABC123...";
```

Save the file.

## 6. Run the frontend

You just need to open the file in a browser — no build step required. Easiest way, from
the `frontend` folder:

```bash
npx serve .
```

(or just double-click `index.html` to open it directly, though some browsers restrict
wallet connections on `file://` pages, so `npx serve .` is the more reliable option)

Then visit the URL it prints (usually `http://localhost:3000`).

## 7. Use it

1. Click **Connect wallet** — MetaMask will pop up. Approve the connection.
   - If BOT Chain Testnet isn't already added to MetaMask, the app will prompt you to add it automatically.
2. Type a task and hit **Add** — MetaMask will ask you to confirm the transaction (this costs a tiny amount of testnet BOT for gas).
3. Once confirmed, your task appears in the list, pulled directly from the chain.
4. Click **✓** to mark a task complete, or **✕** to delete it — both are on-chain transactions too.

## How it works, briefly

- Every wallet address has its own private array of `Task` structs stored in the contract.
- `getMyTasks()` is a **read** call — free, instant, no transaction needed.
- `addTask`, `completeTask`, and `deleteTask` are **writes** — each one is a real
  transaction that costs a small amount of gas and takes a few seconds to confirm.
- The frontend never touches your private key — MetaMask holds that and signs
  transactions on your behalf when you approve them.

## Going to mainnet (later, once you're confident)

Mainnet BOT isn't available from a faucet — you'd need to acquire it via BOT Chain's DEX
(https://dex.botchain.ai/#/swap) first. When you're ready:

```bash
npm run deploy:mainnet
```

Then update `CONTRACT_ADDRESS` in the frontend and change the network config to point at
mainnet (chain ID 677, RPC `https://rpc.botchain.ai`) instead of testnet. Treat this as a
one-way door — test thoroughly on testnet first.
