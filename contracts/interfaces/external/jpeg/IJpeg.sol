// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

interface IJpeg {
    function borrow(
        uint256 _nftIndex,
        uint256 _amount,
        bool _useInsurance
    ) external;
}