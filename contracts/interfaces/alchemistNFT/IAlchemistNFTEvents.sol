pragma solidity >=0.5.0;

/// @title  IAlchemistV2Events
/// @author Alchemix Finance
interface IAlchemistNFTEvents {
    /// @notice Emitted when the pending admin is updated.
    event Initialized(address indexed alchemist, address indexed cryptopunk);
}