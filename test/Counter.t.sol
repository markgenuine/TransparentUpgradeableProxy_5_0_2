// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { Vm } from "forge-std/Vm.sol";
import { Test, console } from "forge-std/Test.sol";
import { Counter } from "src/Counter.sol";
import { CounterScript } from "script/Counter.s.sol";

import { ProxyAdmin } from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import { IERC1967 } from "@openzeppelin/contracts/interfaces/IERC1967.sol";
import { ITransparentUpgradeableProxy } from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract CounterTest is Test {
    Counter public counter;
    address proxyAdmin;

    function setUp() public {
        CounterScript counterDeploy = new CounterScript();

        vm.recordLogs();
        counter = Counter(counterDeploy.run());
        Vm.Log[] memory entries = vm.getRecordedLogs();
        (, address addr2) = abi.decode(entries[3].data, (address, address));
        if (
            (keccak256("OwnershipTransferred(address,address)") == entries[2].topics[0])
                && (entries[2].emitter == addr2)
        ) {
            proxyAdmin = entries[2].emitter;
        }

        assertEq(counter.number(), uint256(20));
        counter.setNumber(0);
        assertEq(counter.number(), uint256(0));
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function test_UpgradeProxy() public {
        counter.increment();
        counter.increment();

        Counter counterImpl = new Counter{ salt: keccak256("test") }();
        vm.expectEmit(true, false, false, false);
        emit IERC1967.Upgraded(address(counterImpl));
        ProxyAdmin(proxyAdmin).upgradeAndCall(
            ITransparentUpgradeableProxy(address(counter)), address(counterImpl), bytes("")
        );

        assertEq(counter.number(), 2);
    }

    function testFuzz_SetNumber(
        uint256 x
    ) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
