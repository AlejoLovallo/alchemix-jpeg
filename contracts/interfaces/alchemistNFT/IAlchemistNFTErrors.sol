pragma solidity >=0.8.0;

/// @title  IAlchemistNFTErrors
/// @author Alchemix Finance
///
/// @notice Specifies errors.
interface IAlchemistNFTErrors {

    /// @notice
    error NFTAlreadyUsed(address user, address nft, uint256 nftId);
}