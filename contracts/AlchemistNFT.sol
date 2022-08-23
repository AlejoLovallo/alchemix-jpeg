pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "./interfaces/external/jpeg/IJpeg.sol";
import "./interfaces/external/curve/ICurve.sol";
import "./interfaces/IAlchemistNFT.sol";
import "./interfaces/IAlchemistV2.sol";
import "./interfaces/INFTWrapper.sol";
import "./libraries/Sets.sol";
import "./base/Errors.sol";

/// @title  AlchemistNFT
/// @author Alchemix Finance
contract AlchemistNFT is Initializable, IAlchemistNFT, IERC721Receiver{
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
    using SafeERC20 for IERC20;

    struct Account {
        /// @notices nftIndexes
        EnumerableSetUpgradeable.UintSet nftsDeposited;
    }

    struct CurveData{
        address Curve;
        uint8 pUsdIndex;
    }

    address public admin;
    address public pendingAdmin;
    address public Alchemist;
    address public NFTWrapper;
    address public Jpeg;
    CurveData public curveData;

    IERC20 public pUsd;

    /// @notice user to nft collection to account data
    mapping(address => mapping(address => Account)) private users;

    function initialize(address _alchemist,
                        address _nftWrapper, 
                        address _jpeg,
                        address _pUsd,
                        address _admin,
                        CurveData memory _curveData) public initializer{
        Alchemist = _alchemist;
        NFTWrapper = _nftWrapper;
        Jpeg = _jpeg;
        curveData = CurveData({
            Curve: _curveData.Curve,
            pUsdIndex: _curveData.pUsdIndex
        });

        pUsd = IERC20(_pUsd);
        admin = _admin;

        emit Initialized(_alchemist,_nftWrapper,_jpeg,address(curveData.Curve));
    }

    function setPendingAdmin(address value) external override {
        _onlyAdmin();
        pendingAdmin = value;
        emit PendingAdminUpdated(value);
    }

    function acceptAdmin() external override {
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
                     address underlyingToken,
                     address yieldToken,
                     uint256 curveTokenIndex) public override returns(uint256){
        _checkNFT(msg.sender,_nft,_nftId);

        //GET NFT
        INFTWrapper(NFTWrapper).safeTransferFrom(msg.sender,address(this),_nftId);


        //INTERACTION WITH JPEG PROTOCOL 
        uint256 prePUsdBalance = pUsd.balanceOf(address(this));
        IJpeg(Jpeg).borrow(_nftId,amountToBorrow,false);
        uint256 postPUsdBalance = pUsd.balanceOf(address(this));
        require(postPUsdBalance > prePUsdBalance,"BORROW PUSD WENT WRONG");

        //SWAP PUSD FOR STABLE
        uint256 preStableTokenBalance = IERC20(underlyingToken).balanceOf(address(this));
        ICurve(curveData.Curve).exchange(curveData.pUsdIndex,
                        curveTokenIndex,
                        ( (postPUsdBalance-prePUsdBalance) /2),
                        0
                        );
        uint256 postStableTokenBalance = IERC20(underlyingToken).balanceOf(address(this));
        require(postStableTokenBalance > preStableTokenBalance,"PUSD-UNDERLYING_TOKEN EXCHANGE WENT WRONG");

        // INTERACTION WITH ALCHEMISTV2 VAULT
        uint256 shares = IAlchemistV2(Alchemist).depositUnderlying(yieldToken,
                        (postStableTokenBalance - preStableTokenBalance),
                        msg.sender,
                        (postStableTokenBalance - preStableTokenBalance)
                    );
        //MINT allUSD
        IAlchemistV2(Alchemist).mintFrom(msg.sender,(shares/2),msg.sender);
        
        emit NFTLocked(msg.sender,
                       _nft,
                       _nftId,
                       (postPUsdBalance-prePUsdBalance),
                       (postStableTokenBalance-preStableTokenBalance),
                       shares
                      );
        return shares;
    }  


    function unlockNFT(address _nft,
                       uint256 _nftId,
                       uint256 amountToRepay,
                       address underlyingToken,
                       address yieldToken,
                       uint256 curveTokenIndex) public override {
        _checkNFT(msg.sender,_nft,_nftId);

        //FIRST TRANSFER THE UNDERLYING TOKEN TO THE CONTRACT
        uint256 preUnderlyingTokenBalance = IERC20(underlyingToken).balanceOf(address(this));
        IERC20(underlyingToken).safeTransferFrom(msg.sender,address(this),amountToRepay);
        uint256 postUnderlyingTokenBalance = IERC20(underlyingToken).balanceOf(address(this));
        require(postUnderlyingTokenBalance > preUnderlyingTokenBalance, "TRANSFER UNDERLYING TOKEN WENT WRONG");

        //REPAY ALCHEMIXV2  
        uint256 tokensRepaid = IAlchemistV2(Alchemist).repay(
                            underlyingToken,
                            amountToRepay,
                            msg.sender
        );

        (uint256 shares,) = IAlchemistV2(Alchemist).positions(msg.sender,yieldToken);

        //WITHDRAW UNDERLYING
        preUnderlyingTokenBalance = IERC20(underlyingToken).balanceOf(address(this));
        uint256 pps = IAlchemistV2(Alchemist).getUnderlyingTokensPerShare(yieldToken);
        IAlchemistV2(Alchemist).withdrawUnderlyingFrom(msg.sender,
                                                            yieldToken,
                                                            (shares / pps),
                                                            address(this),
                                                            1
                                    );
        postUnderlyingTokenBalance = IERC20(underlyingToken).balanceOf(address(this));
        require(postUnderlyingTokenBalance > preUnderlyingTokenBalance, "WITHDRAW UNDERLYING TOKEN WENT WRONG");

        //SWAP IN CURVE
        uint256 prePUsdBalance = pUsd.balanceOf(address(this));
        ICurve(curveData.Curve).exchange(curveTokenIndex,
                        curveData.pUsdIndex,
                        ( (postUnderlyingTokenBalance - preUnderlyingTokenBalance) /2),
                        0
                        );
        uint256 postPUsdBalance = pUsd.balanceOf(address(this));
        require(postPUsdBalance > prePUsdBalance,"UNDERLYING_TOKEN-PUSD EXCHANGE WENT WRONG");

        //REPAY IN JPEG AND GET NFT BACK
        IJpeg(Jpeg).repay(_nftId,postPUsdBalance);
        IJpeg(Jpeg).closePosition(_nftId);

        //FINALLY GET NFT BACK
        INFTWrapper(NFTWrapper).safeTransferFrom(address(this),msg.sender,_nftId);

        emit NFTUnlocked(msg.sender,
                         _nft,
                         _nftId,
                         tokensRepaid
        );
    }

    function setUpJpeg(address nft) external override {
        INFTWrapper(NFTWrapper).setApprovalForAll(nft,true);
    }

    function setUpCurve(address token, uint256 amount) external override{
        IERC20(token).safeApprove(curveData.Curve,amount);
    }

    function setUpAlchemistV2(address token,uint256 amount) external override{
        _onlyAdmin();
        IERC20(token).safeApprove(Alchemist,amount);
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
        if(users[_user][_nft].nftsDeposited.contains(_nftId)){
            revert NFTAlreadyUsed(_user,_nft,_nftId);
        }
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
