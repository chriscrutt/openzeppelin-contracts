// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../math/Math.sol";

contract MathMock {
    function max(uint a, uint b) public pure returns (uint) {
        return Math.max(a, b);
    }

    function min(uint a, uint b) public pure returns (uint) {
        return Math.min(a, b);
    }

    function average(uint a, uint b) public pure returns (uint) {
        return Math.average(a, b);
    }
}
