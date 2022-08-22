pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "./interfaces/INFTWrapper.sol";
import "./interfaces/IAlchemistV2.sol";
import "./libraries/Sets.sol";

/// @title  AlchemistNFT
/// @author Alchemix Finance
contract AlchemistNFT is Initializable, IAlchemistV2, IERC721Receiver{
    using Sets for Sets.AddressSet;

    struct Account {
        // The set of yield tokens that the account has deposited into the system.
        Sets.AddressSet depositedTokens;
    }

    IAlchemistV2 immutable public Alchemist;
    INFTWrapper immutable public NFTWrapper;

    /// @notice user to nft transfered to vaule
    mapping(address => Account) private users;

    constructor(address _alchemist,address _nftWrapper) initializer {
        Alchemist = IAlchemistV2(_alchemist);
        NFTWrapper = INFTWrapper(_nftWrapper);

        emit Initialized(Alchemist,NFTWrapper);
    }

    function lockNFT(address _nft,address _nftId) public override returns (boolean){
        _checkNFT(msg.sender,_nft);
        
    }

    function _checkNFT(address _user,address _nft) internal view {
        if(users[_user].depositedTokens.contains(_nft)){
            revert NFTAlreadyUsed(_user,_nft);
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
