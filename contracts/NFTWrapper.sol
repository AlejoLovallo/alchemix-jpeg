pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "./interfaces/INFTWrapper.sol";

/// @title  AlchemistJPEG
/// @author Alchemix Finance
contract NFTWrapper is Initializable, INFTWrapper{

  function initialize() public initializer {

  }

  function safeTransferFrom(address, address,uint256) public override {

  }

  function setApprovalForAll(address operator, bool _approved) public override {

  }
}