// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Counter is Initializable {
    uint256 public number;

    constructor() {
        _disableInitializers();
    }

    function initialize(
        uint256 startNumber
    ) public {
        number = startNumber;
    }

    function setNumber(
        uint256 newNumber
    ) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
