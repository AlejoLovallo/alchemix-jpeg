/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type {
  IAlchemistNFTErrors,
  IAlchemistNFTErrorsInterface,
} from "../IAlchemistNFTErrors";

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
];

export class IAlchemistNFTErrors__factory {
  static readonly abi = _abi;
  static createInterface(): IAlchemistNFTErrorsInterface {
    return new utils.Interface(_abi) as IAlchemistNFTErrorsInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IAlchemistNFTErrors {
    return new Contract(address, _abi, signerOrProvider) as IAlchemistNFTErrors;
  }
}