pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "../interfaces/external/drops/ComptrollerInterface.sol";
import "../interfaces/external/drops/CErc721Interface.sol";
import "../interfaces/IAlchemistNFT.sol";
import "../interfaces/IAlchemistV2.sol";
import "../interfaces/INFTWrapper.sol";
import "../libraries/Sets.sol";
import "../base/Errors.sol";

import "hardhat/console.sol";

/// @title  AlchemistNFT
/// @author Alchemix Finance
contract AlchemicDropsNFT is Initializable, IERC721Receiver{
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
    using SafeERC20 for IERC20;

    struct Account {
        /// @notices nftIndexes
        EnumerableSetUpgradeable.UintSet nftsDeposited;
    }


    address public admin;
    address public pendingAdmin;
    address public usdcYieldToken;
    address[] public dropsNftMarkets;


    ComptrollerInterface public DropsComptroller;
    IAlchemistV2 public Alchemist;
    IERC20 public Usdc;
    CErc20Interface public dropsUsdcMarket;

    /// @notice user to nft collection to account data
    mapping(address => mapping(address => Account)) private users;

    /// @notice Emitted when the pending admin is updated.
    ///
    /// @param pendingAdmin The address of the pending admin.
    event PendingAdminUpdated(address pendingAdmin);

    /// @notice Emitted when the administrator is updated.
    ///
    /// @param admin The address of the administrator.
    event AdminUpdated(address admin);

    constructor() {}

    function initialize(address _admin, 
                address _alchemist,
                address _dropsComptroller,
                address _usdc,
                address _usdcYieldToken,
                address _dropsUsdcMarket,
                address[] calldata _dropsNftMarkets
    ) public initializer {
        admin = _admin;
        Alchemist = IAlchemistV2(_alchemist);
        DropsComptroller = ComptrollerInterface(_dropsComptroller);
        Usdc = IERC20(_usdc);
        usdcYieldToken = _usdcYieldToken;
        dropsUsdcMarket = CErc20Interface(_dropsUsdcMarket);
        dropsNftMarkets = _dropsNftMarkets;
        _setUpDrops();
        _setUpAlchemistV2();
    }

    function setPendingAdmin(address value) external {
        _onlyAdmin();
        pendingAdmin = value;
        emit PendingAdminUpdated(value);
    }

    function acceptAdmin() external {
        _checkState(pendingAdmin != address(0));

        if (msg.sender != pendingAdmin) {
            revert Unauthorized();
        }

        admin = pendingAdmin;
        pendingAdmin = address(0);

        emit AdminUpdated(admin);
        emit PendingAdminUpdated(address(0));
    }


    /**
     * For testing purposes lock will be done only against dai stable coin.
     * Also for safety we will ask to exchange the 50% of the pUsd minted on borrowing. 
     */
    function lockNft(address _nft,
                     uint256 _nftId,
                     uint256 amountToBorrow,
                     address dropsNftMarket // TODO instead of asking for this parameter map it to the nft address
                    ) public returns(uint256){
        _checkNFT(msg.sender,_nft,_nftId);

        //GET NFT
        INFTWrapper(_nft).safeTransferFrom(msg.sender, address(this), _nftId);


        //INTERACTION WITH Drops PROTOCOL 
        IERC721(_nft).approve(dropsNftMarket, _nftId);
        uint errorCode = CErc721Interface(dropsNftMarket).mint(_nftId);
        require(errorCode == 0, "Drops Market mint error");
        // TODO add getCash check
        errorCode = dropsUsdcMarket.borrow(amountToBorrow);
        require(errorCode == 0, "Drops Comptroller borrow error");
        

        // INTERACTION WITH ALCHEMISTV2 VAULT
        uint256 shares = Alchemist.depositUnderlying(
            usdcYieldToken,
            amountToBorrow,
             msg.sender,
            1 // TODO use a setter and calculate this 
        );

        //MINT allUSD
        // 50% of maximum shares TODO add it as a parameter for the user
        Alchemist.mint(shares / 2, msg.sender);

        // TODO keep track of the shares and users

        return shares;
    }  


    function unlockNFT() public  {
    }

    /**
     * TODO: APPROVE CONTRACTS WITH AMOUNTS TO ENABLE PROTOCOLS INTERACTIONS
     */

    function _setUpDrops() internal {
        DropsComptroller.enterMarkets(dropsNftMarkets);
    }

    function _setUpAlchemistV2() internal {
        Usdc.approve(address(Alchemist), type(uint).max);

    }

    /// @dev Checks that the `msg.sender` is the administrator.
    ///
    /// @dev `msg.sender` must be the administrator or this call will revert with an {Unauthorized} error.
    function _onlyAdmin() internal view {
        if (msg.sender != admin) {
            revert Unauthorized();
        }
    }

    /// @dev Checks an expression and reverts with an {IllegalState} error if the expression is {false}.
    ///
    /// @param expression The expression to check.
    function _checkState(bool expression) internal pure {
        if (!expression) {
            revert IllegalState();
        }
    }


    function _checkNFT(address _user, address _nft, uint256 _nftId) internal view {
        // TODO Check that is one of the supported NFTS from drops
    }

    /**
     * Always returns `IERC721Receiver.onERC721Received.selector`.
    */
    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // Leave a gap betweeen inherited contracts variables in order
    // to be able to add more variables in them later.
    uint256[50] private upgradeGap;
}
