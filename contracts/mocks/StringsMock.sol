// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../utils/Strings.sol";

contract StringsMock {
    function fromuint(uint value) public pure returns (string memory) {
        return Strings.toString(value);
    }
}
