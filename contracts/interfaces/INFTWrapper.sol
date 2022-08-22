// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

interface INFTWrapper {
    function safeTransferFrom(address, address,uint256) external;
}