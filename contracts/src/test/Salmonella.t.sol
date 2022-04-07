// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../PoisonERC20.sol";
import "./mocks/MockPoisonERC20.sol";

contract PoisonERC20Test is DSTest {
    MockPoisonERC20 poisonERC20;
    Vm vm = Vm(HEVM_ADDRESS);

    address leetOwner = address(1337);
    address leetNonOwner = address(13371337);

    // test setting up the contract and transferring to leetNonOwner, using
    // address(this) as the owner
    function testOwnerThisTransfer() public {
        uint256 amount = 100;

        // create a new poison token with owner address(1337), which we'll fill
        poisonERC20 = new MockPoisonERC20("SneakyToken", "STK", 0, 90, address(this));

        // give some to leetOwner
        poisonERC20.mint(address(this), amount);

        // transfer to leetNonOwner
        poisonERC20.transfer(leetNonOwner, amount);

        // transfer and make sure the supply is the same
        assertEq(poisonERC20.totalSupply(), amount);
    }

    // test setting up the contract and siphoning funds
    function testNonOwnerTransfer() public {
        uint256 amount = 100;

        // create a new poison token with owner address(1337), which we'll fill
        poisonERC20 = new MockPoisonERC20("SneakyToken", "STK", 0, 90, leetOwner);

        // give some to leetOwner
        poisonERC20.mint(address(this), amount);
        assertEq(poisonERC20.balanceOf(address(this)), amount);

        // approve and transfer to leetNonOwner
        poisonERC20.approve(address(this), amount);
        poisonERC20.transferFrom(address(this), leetNonOwner, amount);

        // check that receiver is 90, sender is 0, owner is 10
        assertEq(poisonERC20.balanceOf(leetOwner), 10);
        assertEq(poisonERC20.balanceOf(leetNonOwner), 90);
        assertEq(poisonERC20.balanceOf(address(this)), 0);
    }
}
