/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { IAlchemistNFT, IAlchemistNFTInterface } from "../IAlchemistNFT";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "user",
        type: "address",
      },
      {
        internalType: "address",
        name: "nft",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "nftId",
        type: "uint256",
      },
    ],
    name: "NFTAlreadyUsed",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "admin",
        type: "address",
      },
    ],
    name: "AdminUpdated",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "Alchemist",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "NFTWrapper",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "Jpeg",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "Curve",
        type: "address",
      },
    ],
    name: "Initialized",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "user",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "nft",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "nftId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "pUsdMinted",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "daiDeposited",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "shares",
        type: "uint256",
      },
    ],
    name: "NFTLocked",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "user",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "nft",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "nftId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "alchemixTokensRepaid",
        type: "uint256",
      },
    ],
    name: "NFTUnlocked",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "pendingAdmin",
        type: "address",
      },
    ],
    name: "PendingAdminUpdated",
    type: "event",
  },
  {
    inputs: [],
    name: "acceptAdmin",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_nft",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_nftId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "amountToBorrow",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "underlyingToken",
        type: "address",
      },
      {
        internalType: "address",
        name: "yieldToken",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "curveTokenIndex",
        type: "uint256",
      },
    ],
    name: "lockNft",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "value",
        type: "address",
      },
    ],
    name: "setPendingAdmin",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_nft",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_nftId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "amountToBorrow",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "underlyingToken",
        type: "address",
      },
      {
        internalType: "address",
        name: "yieldToken",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "curveTokenIndex",
        type: "uint256",
      },
    ],
    name: "unlockNFT",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

export class IAlchemistNFT__factory {
  static readonly abi = _abi;
  static createInterface(): IAlchemistNFTInterface {
    return new utils.Interface(_abi) as IAlchemistNFTInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IAlchemistNFT {
    return new Contract(address, _abi, signerOrProvider) as IAlchemistNFT;
  }
}
