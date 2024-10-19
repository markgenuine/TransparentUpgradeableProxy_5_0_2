# OpenZeppelin v5.0.2 TransparentUpgradeableProxy.
### Use with Foundry: Deploy and Upgrade contract.

### Install

```shell
$ forge install
```

### Test

```shell
$ forge test -vvvv
```

### Description
Old version TransparentUpgradeableProxy on deploy and upgrade you was be must took in advance deploy <b>ProxyAdmin</b> but on new version it's chanded.
And now, you must specify in <b>TransparentUpgradeableProxy</b> initialOwner and inside the proxy will deploy <b>ProxyAdmin</b>.
It is not possible to get the address of a simple call from the contract, this creates problems in testing and other functionality.

We have several various:
- Change visibility function <b>getAdmin()</b> contract <b>TransparentUpgradeableProxy</b> what not true.
- Get b><ProxyAdmin</b> address from events and logs. We can use.
```solidity
    vm.recordLogs();
    ...............
    ...............
    Vm.Log[] memory entries = vm.getRecordedLogs();
```
Get <b>ProxyAdmin</b> address from Logs foundry and array entries.

Simple contract: [Counter.sol](https://github.com/markgenuine/TransparentUpgradeableProxy_5_0_2/src/Counter.sol)

Script deploy contract: [Counter.s.sol](https://github.com/markgenuine/TransparentUpgradeableProxy_5_0_2/script/Counter.s.sol)

Tests contract: [Counter.t.sol](https://github.com/markgenuine/TransparentUpgradeableProxy_5_0_2/test/Counter.sol)