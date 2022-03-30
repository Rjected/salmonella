// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "ds-test/test.sol";
import "forge-std/Vm.sol";
import "solmate/test/utils/mocks/MockERC20.sol";
import "../PoisonERC20.sol";
import "../Salmonella.sol";

contract PoisonERC20Test is DSTest {
    PoisonERC20 poisonERC20;
    Vm vm = Vm(HEVM_ADDRESS);

    address leetOwner = address(1337);

    // TODO: use inheritance in the token
    function setUp() public {
        // create a new poison token with owner address(1337), which we'll fill
        poisonERC20 = new Salmonella("SneakyToken", "STK", 0, 10, leetOwner);
    }

    // TODO: test that we match mockerc20 when owner = 1337, otherwise we should
    // make sure we do NOT

    // TODO: uniswap test setup?
}
