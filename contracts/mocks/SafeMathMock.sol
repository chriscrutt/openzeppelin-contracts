// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../math/SafeMath.sol";

contract SafeMathMock {
    function mul(uint a, uint b) public pure returns (uint) {
        return SafeMath.mul(a, b);
    }

    function div(uint a, uint b) public pure returns (uint) {
        return SafeMath.div(a, b);
    }

    function sub(uint a, uint b) public pure returns (uint) {
        return SafeMath.sub(a, b);
    }

    function add(uint a, uint b) public pure returns (uint) {
        return SafeMath.add(a, b);
    }

    function mod(uint a, uint b) public pure returns (uint) {
        return SafeMath.mod(a, b);
    }
}
