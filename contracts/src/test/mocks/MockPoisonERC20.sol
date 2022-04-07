// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {PoisonERC20} from "../../PoisonERC20.sol";

contract MockPoisonERC20 is PoisonERC20 {
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint8 _trapFactor,
        address _trapOwner
    ) PoisonERC20(_name, _symbol, _decimals, _trapFactor, _trapOwner) {}

    function mint(address to, uint256 value) public virtual {
        _mint(to, value);
    }

    function burn(address from, uint256 value) public virtual {
        _burn(from, value);
    }
}
