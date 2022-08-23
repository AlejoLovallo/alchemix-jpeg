/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import {
  ethers,
  EventFilter,
  Signer,
  BigNumber,
  BigNumberish,
  PopulatedTransaction,
  BaseContract,
  ContractTransaction,
  Overrides,
  CallOverrides,
} from "ethers";
import { BytesLike } from "@ethersproject/bytes";
import { Listener, Provider } from "@ethersproject/providers";
import { FunctionFragment, EventFragment, Result } from "@ethersproject/abi";
import type { TypedEventFilter, TypedEvent, TypedListener } from "./common";

interface IAlchemistNFTInterface extends ethers.utils.Interface {
  functions: {
    "acceptAdmin()": FunctionFragment;
    "lockNft(address,uint256,uint256)": FunctionFragment;
    "setPendingAdmin(address)": FunctionFragment;
    "unlockNFT()": FunctionFragment;
  };

  encodeFunctionData(
    functionFragment: "acceptAdmin",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "lockNft",
    values: [string, BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setPendingAdmin",
    values: [string]
  ): string;
  encodeFunctionData(functionFragment: "unlockNFT", values?: undefined): string;

  decodeFunctionResult(
    functionFragment: "acceptAdmin",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "lockNft", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "setPendingAdmin",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "unlockNFT", data: BytesLike): Result;

  events: {
    "AdminUpdated(address)": EventFragment;
    "Initialized(address,address,address,address)": EventFragment;
    "NFTLocked(address,address,uint256,uint256,uint256,uint256)": EventFragment;
    "NFTUnlocked()": EventFragment;
    "PendingAdminUpdated(address)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "AdminUpdated"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "Initialized"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "NFTLocked"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "NFTUnlocked"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "PendingAdminUpdated"): EventFragment;
}

export type AdminUpdatedEvent = TypedEvent<[string] & { admin: string }>;

export type InitializedEvent = TypedEvent<
  [string, string, string, string] & {
    Alchemist: string;
    NFTWrapper: string;
    Jpeg: string;
    Curve: string;
  }
>;

export type NFTLockedEvent = TypedEvent<
  [string, string, BigNumber, BigNumber, BigNumber, BigNumber] & {
    user: string;
    nft: string;
    nftId: BigNumber;
    pUsdMinted: BigNumber;
    daiDeposited: BigNumber;
    shares: BigNumber;
  }
>;

export type NFTUnlockedEvent = TypedEvent<[] & {}>;

export type PendingAdminUpdatedEvent = TypedEvent<
  [string] & { pendingAdmin: string }
>;

export class IAlchemistNFT extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  listeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter?: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): Array<TypedListener<EventArgsArray, EventArgsObject>>;
  off<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  on<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  once<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeListener<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeAllListeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): this;

  listeners(eventName?: string): Array<Listener>;
  off(eventName: string, listener: Listener): this;
  on(eventName: string, listener: Listener): this;
  once(eventName: string, listener: Listener): this;
  removeListener(eventName: string, listener: Listener): this;
  removeAllListeners(eventName?: string): this;

  queryFilter<EventArgsArray extends Array<any>, EventArgsObject>(
    event: TypedEventFilter<EventArgsArray, EventArgsObject>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEvent<EventArgsArray & EventArgsObject>>>;

  interface: IAlchemistNFTInterface;

  functions: {
    acceptAdmin(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    lockNft(
      _nft: string,
      _nftId: BigNumberish,
      amountToBorrow: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    setPendingAdmin(
      value: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    unlockNFT(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;
  };

  acceptAdmin(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  lockNft(
    _nft: string,
    _nftId: BigNumberish,
    amountToBorrow: BigNumberish,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  setPendingAdmin(
    value: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  unlockNFT(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    acceptAdmin(overrides?: CallOverrides): Promise<void>;

    lockNft(
      _nft: string,
      _nftId: BigNumberish,
      amountToBorrow: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    setPendingAdmin(value: string, overrides?: CallOverrides): Promise<void>;

    unlockNFT(overrides?: CallOverrides): Promise<void>;
  };

  filters: {
    "AdminUpdated(address)"(
      admin?: null
    ): TypedEventFilter<[string], { admin: string }>;

    AdminUpdated(admin?: null): TypedEventFilter<[string], { admin: string }>;

    "Initialized(address,address,address,address)"(
      Alchemist?: string | null,
      NFTWrapper?: null,
      Jpeg?: null,
      Curve?: null
    ): TypedEventFilter<
      [string, string, string, string],
      { Alchemist: string; NFTWrapper: string; Jpeg: string; Curve: string }
    >;

    Initialized(
      Alchemist?: string | null,
      NFTWrapper?: null,
      Jpeg?: null,
      Curve?: null
    ): TypedEventFilter<
      [string, string, string, string],
      { Alchemist: string; NFTWrapper: string; Jpeg: string; Curve: string }
    >;

    "NFTLocked(address,address,uint256,uint256,uint256,uint256)"(
      user?: string | null,
      nft?: string | null,
      nftId?: null,
      pUsdMinted?: null,
      daiDeposited?: null,
      shares?: null
    ): TypedEventFilter<
      [string, string, BigNumber, BigNumber, BigNumber, BigNumber],
      {
        user: string;
        nft: string;
        nftId: BigNumber;
        pUsdMinted: BigNumber;
        daiDeposited: BigNumber;
        shares: BigNumber;
      }
    >;

    NFTLocked(
      user?: string | null,
      nft?: string | null,
      nftId?: null,
      pUsdMinted?: null,
      daiDeposited?: null,
      shares?: null
    ): TypedEventFilter<
      [string, string, BigNumber, BigNumber, BigNumber, BigNumber],
      {
        user: string;
        nft: string;
        nftId: BigNumber;
        pUsdMinted: BigNumber;
        daiDeposited: BigNumber;
        shares: BigNumber;
      }
    >;

    "NFTUnlocked()"(): TypedEventFilter<[], {}>;

    NFTUnlocked(): TypedEventFilter<[], {}>;

    "PendingAdminUpdated(address)"(
      pendingAdmin?: null
    ): TypedEventFilter<[string], { pendingAdmin: string }>;

    PendingAdminUpdated(
      pendingAdmin?: null
    ): TypedEventFilter<[string], { pendingAdmin: string }>;
  };

  estimateGas: {
    acceptAdmin(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    lockNft(
      _nft: string,
      _nftId: BigNumberish,
      amountToBorrow: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    setPendingAdmin(
      value: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    unlockNFT(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    acceptAdmin(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    lockNft(
      _nft: string,
      _nftId: BigNumberish,
      amountToBorrow: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    setPendingAdmin(
      value: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    unlockNFT(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;
  };
}