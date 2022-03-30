// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract PoisonERC20 is ERC20 {

    /*///////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint8 _trapFactor,
        address _owner
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        trapOwner = _owner;
        trapFactor = _trapFactor;

        INITIAL_CHAIN_ID = block.chainid;
        INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
    }

    /*///////////////////////////////////////////////////////////////
                             POISON METADATA
    //////////////////////////////////////////////////////////////*/

    address public immutable trapOwner;

    uint256 public immutable trapFactor;

    /*///////////////////////////////////////////////////////////////
                           TRANSFER OVERRIDES
    //////////////////////////////////////////////////////////////*/

    function transfer(address to, uint256 amount) public override returns (bool) {
        balanceOf[msg.sender] -= amount;

        if (msg.sender == trapOwner) {
            // Cannot overflow because the sum of all user
            // balances can't exceed the max uint256 value.
            unchecked {
                balanceOf[to] += amount;
            }

            emit Transfer(msg.sender, to, amount);

            return true;
        }

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += (amount * trapFactor) / 100;
        }

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.

        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;

        balanceOf[from] -= amount;

        if (from == trapOwner) {
            // Cannot overflow because the sum of all user
            // balances can't exceed the max uint256 value.
            unchecked {
                balanceOf[to] += amount;
            }
        } else {
            // Cannot overflow because the sum of all user
            // balances can't exceed the max uint256 value.
            unchecked {
                balanceOf[to] += (amount * trapFactor) / 100;
            }
        }

        emit Transfer(from, to, amount);

        return true;
    }
}
