// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Multisig.sol";

contract MultiSigFactory {
    //a factory contract that create multiple clones of multisig.sol
    //a function that create a new multisig
    //an array that holds contract addresses created
    //a function that calls the approve function in multisig.sol
    // a function that calls the withdraw function in multisig.sol

    MultiSig[] multiSigAddresses;
    event newClone(MultiSig indexed, uint256 indexed position);

    function cloneMultiSig(address[] memory _validOwners)
        external
        returns (MultiSig NewMS, uint256 _length)
    {
        NewMS = new MultiSig(_validOwners);
        multiSigAddresses.push(NewMS);
        _length = multiSigAddresses.length;
        emit newClone(NewMS, _length);
    }

    function ClonedAddresses()
        external
        view
        returns (MultiSig[] memory _multisig)
    {
        _multisig = multiSigAddresses;
    }
}



//hardhat deployment script for the above contract
//|| || ||
//________

import { ethers } from "hardhat";

async function main() {

let [valid1, valid2, valid3, valid4, valid5] = await ethers.getSigners();

const MultisigFactory = await ethers.getContractFactory("MultiSigFactory");
const multisigFactory = await MultisigFactory.deploy();

await multisigFactory.deployed();

console.log(
"factory contract deployed to this address",
multisigFactory.address
);
let cloned = await multisigFactory.cloneMultiSig([
valid1.address,
valid2.address,
valid3.address,
valid4.address,
valid5.address,
]);

const clone2 = await multisigFactory
.connect(valid2)
.cloneMultiSig([
valid1.address,
valid2.address,
valid3.address,
valid4.address,
valid5.address,
]);
let result = (await clone2.wait()).logs[0].topics.length;
let result1 = (await clone2.wait()).logs[0].topics[0];
let result2 = (await clone2.wait()).logs[0].topics[1];
let result3 = (await clone2.wait()).logs[0].topics[2];

console.log(result, "factory cloned successfully");
console.log("we are the logger", result1, result2, result3);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
console.error(error);
process.exitCode = 1;
});