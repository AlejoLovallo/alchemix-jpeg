pragma solidity >=0.5.0;

/// @title  IAlchemistV2Events
/// @author Alchemix Finance
interface IAlchemistNFTEvents {
    /// @notice Emitted when the pending admin is updated.
    event Initialized(address indexed Alchemist, address NFTWrapper, address Jpeg, address Curve);

    /// @notice Emitted when the pending admin is updated.
    ///
    /// @param pendingAdmin The address of the pending admin.
    event PendingAdminUpdated(address pendingAdmin);

    /// @notice Emitted when the administrator is updated.
    ///
    /// @param admin The address of the administrator.
    event AdminUpdated(address admin);

    /**
     * msg.sender,
                       _nft,
                       _nftId,
                       (postPUsdBalance-prePUsdBalance),
                       (postDAIBalance-preDAIBalance),
                       shares
     */


    /// @notice
    event NFTLocked(address indexed user, 
                    address indexed nft, 
                    uint256 nftId,
                    uint256 pUsdMinted,
                    uint256 daiDeposited,
                    uint256 shares
    );

    /// @notice
    event NFTUnlocked();
}