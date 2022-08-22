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
        uint8 usdtIndex;
        uint8 usdcIndex;
        uint8 daiIndex;
        uint8 pUsdIndex;
    }


    address immutable public Alchemist;
    address immutable public NFTWrapper;
    address immutable public Jpeg;
    CurveData public curveData;

    IERC20 immutable public pUsd;
    IERC20 immutable public DAI;


    /// @notice user to nft collection to account data
    mapping(address => mapping(address => Account)) private users;

    constructor(address _alchemist,
                address _nftWrapper, 
                address _jpeg,
                address _dai,
                address _pUsd,
                CurveData memory _curveData
                ) initializer {
        Alchemist = _alchemist;
        NFTWrapper = _nftWrapper;
        Jpeg = _jpeg;
        curveData = CurveData({
            Curve: _curveData.Curve,
            usdtIndex: _curveData.usdtIndex,
            usdcIndex: _curveData.usdcIndex,
            daiIndex:  _curveData.daiIndex,
            pUsdIndex: _curveData.pUsdIndex
        });

        DAI = IERC20(_dai);
        pUsd = IERC20(_pUsd);

        emit Initialized(_alchemist,_nftWrapper,_jpeg,address(curveData.Curve));
    }

    /**
     * FOR Testing purposes lock will be done only against dai stable coin.
     * Also for safety we will ask to exchange the 50% of the pUsd minted on borrowing. 
     */
    function lockNft(address _nft,
                     uint256 _nftId,
                     address swap,
                     uint256 amountToBorrow) public override{
        _checkNFT(msg.sender,_nft,_nftId);

        //GET NFT
        INFTWrapper(NFTWrapper).safeTransferFrom(msg.sender,address(this),_nftId);


        //INTERACTION WITH JPEG PROTOCOL 
        uint256 prePUsdBalance = pUsd.balanceOf(address(this));
        IJpeg(Jpeg).borrow(_nftId,amountToBorrow,false);
        uint256 postPUsdBalance = pUsd.balanceOf(address(this));
        require(postPUsdBalance > prePUsdBalance,"BORROW PUSD WENT WRONG");

        //SWAP PUSD FOR STABLE
        uint256 preDAIBalance = DAI.balanceOf(address(this));
        ICurve(curveData.Curve).exchange(curveData.pUsdIndex,
                        curveData.daiIndex,
                        (postPUsdBalance/2),
                        0
                        );
        require(DAI.balanceOf(address(this))> preDAIBalance,"PUSD-DAI EXCHANGE WENT WRONG");

        // INTERACTION WITH ALCHEMISTV2
        
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
