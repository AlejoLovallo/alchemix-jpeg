// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

interface INFTWrapper {
    function setApprovalForAll(address operator, bool _approved) external;
    function safeTransferFrom(address, address,uint256) external;
}