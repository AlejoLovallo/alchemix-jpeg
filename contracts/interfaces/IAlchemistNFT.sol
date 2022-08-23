pragma solidity ^0.8.11;

import "./alchemistNFT/IAlchemistNFTErrors.sol";
import "./alchemistNFT/IAlchemistNFTEvents.sol";

interface IAlchemistNFT is IAlchemistNFTErrors, IAlchemistNFTEvents {
   function lockNft(address _nft,uint256 _nftId,uint256 amountToBorrow,address underlyingToken,address yieldToken,uint256 curveTokenIndex) external returns(uint256);

   function unlockNFT(address _nft,uint256 _nftId,uint256 amountToBorrow,address underlyingToken,address yieldToken,uint256 curveTokenIndex) external;

   function setUpAlchemistV2(address token,uint256 amount) external;

   function setUpJpeg(address nft) external;

   function setUpCurve(address token, uint256 amount) external;

   function setPendingAdmin(address value) external;

   function acceptAdmin() external;

}