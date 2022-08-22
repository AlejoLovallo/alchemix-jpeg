pragma solidity ^0.8.11;

import "./alchemistNFT/IAlchemistNFTErrors.sol";
import "./alchemistNFT/IAlchemistNFTEvents.sol";

interface IAlchemistNFT is IAlchemistNFTErrors, IAlchemistNFTEvents {
   function lockNft(address _nft,uint256 _nftId,address swap,uint256 amountToBorrow) external;
}