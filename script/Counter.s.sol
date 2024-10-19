// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { Script, console } from "forge-std/Script.sol";
import { Counter } from "../src/Counter.sol";
import { TransparentUpgradeableProxy } from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract CounterScript is Script {
    Counter public counter;

    function run() public returns (address) {
        vm.startBroadcast();

        counter = new Counter();

        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(
            address(counter), address(msg.sender), abi.encodeCall(Counter.initialize, (uint256(20)))
        );

        vm.stopBroadcast();

        return address(proxy);
    }
}
