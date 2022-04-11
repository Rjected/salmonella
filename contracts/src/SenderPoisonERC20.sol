// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {PoisonERC20} from "./PoisonERC20.sol";

contract SenderPoisonERC20 is PoisonERC20 {
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint8 _trapFactor,
        uint256 initialSupply
    ) PoisonERC20(_name, _symbol, _decimals, _trapFactor, msg.sender) {
        _mint(msg.sender, initialSupply);
    }
}
