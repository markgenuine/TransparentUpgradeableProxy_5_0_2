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
    address proxy;
    address proxyAdmin;

    function setUp() public {
        CounterScript counterDeploy = new CounterScript();

        vm.recordLogs();
        proxy = counterDeploy.run();
        Vm.Log[] memory entries = vm.getRecordedLogs();
        (, address addr2) = abi.decode(entries[3].data, (address, address));
        if (
            (keccak256("OwnershipTransferred(address,address)") == entries[2].topics[0])
                && (entries[2].emitter == addr2)
        ) {
            proxyAdmin = entries[2].emitter; //TODO
        }

        assertEq(Counter(proxy).number(), uint256(20));
        Counter(proxy).setNumber(0);
        assertEq(Counter(proxy).number(), uint256(0));
    }

    function test_Increment() public {
        Counter(proxy).increment();
        assertEq(Counter(proxy).number(), 1);
    }

    function test_UpgradeProxy() public {
        Counter(proxy).increment();
        Counter(proxy).increment();

        Counter counter2 = new Counter{ salt: keccak256("test") }();
        vm.expectEmit(true, false, false, false);
        emit IERC1967.Upgraded(address(counter2));
        ProxyAdmin(proxyAdmin).upgradeAndCall(ITransparentUpgradeableProxy(proxy), address(counter2), bytes(""));

        assertEq(Counter(proxy).number(), 2);
    }

    function testFuzz_SetNumber(
        uint256 x
    ) public {
        Counter(proxy).setNumber(x);
        assertEq(Counter(proxy).number(), x);
    }
}
