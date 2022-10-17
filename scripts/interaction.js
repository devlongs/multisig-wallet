const hre = require("hardhat");

async function main() {
  let provider = {
    PrivateKey: process.env.PRIVATE_KEY,
    URL: process.env.URL,
  };
  const provider2 = ethers.getDefaultProvider("ropsten", provider.URL);
  let wallet = new ethers.Wallet(provider.PrivateKey, provider2);
  const _value = ethers.utils.parseEther("1");

  const CONTRACTADDRESS = "0x6e828b59fc799b6ef92e42d2f39e438a7477f469";
  const MULTISIG = await ethers.getContractAt("IMultiSig", CONTRACTADDRESS);
  //   await wallet.sendTransaction({ to: CONTRACTADDRESS, value: _value });
  //   console.log();
  //   console.log("contractBalanc", await MULTISIG.contractBalance());

  await MULTISIG.withdrawEther(_value);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
