// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../utils/Arrays.sol";

contract ArraysImpl {
    using Arrays for uint[];

    uint[] private _array;

    constructor (uint[] memory array) public {
        _array = array;
    }

    function findUpperBound(uint element) external view returns (uint) {
        return _array.findUpperBound(element);
    }
}
