require("dotenv").config();

const raw = process.env.PRIVATE_KEY;
console.log("TEST = ", raw)

if (!raw) {
  console.log("❌ PRIVATE_KEY is undefined — dotenv isn't finding it.");
  console.log("   Check: is there a .env file in this exact folder?");
  console.log("   Check: does the line read exactly  PRIVATE_KEY=...  with no spaces around =");
  process.exit(1);
}

console.log("Length:", raw.length, "(want 64, or 66 if it includes 0x)");
console.log("Starts with 0x:", raw.startsWith("0x"));
console.log("Has surrounding quotes:", raw.startsWith('"') || raw.startsWith("'"));
console.log("Has trailing whitespace/CR:", /\s$/.test(raw));
console.log("Is valid hex (after stripping 0x):", /^[0-9a-fA-F]+$/.test(raw.replace(/^0x/, "")));