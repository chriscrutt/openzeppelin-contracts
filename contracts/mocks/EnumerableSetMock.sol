// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../utils/EnumerableSet.sol";

// Bytes32Set
contract EnumerableBytes32SetMock {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    event OperationResult(bool result);

    EnumerableSet.Bytes32Set private _set;

    function contains(bytes32 value) public view returns (bool) {
        return _set.contains(value);
    }

    function add(bytes32 value) public {
        bool result = _set.add(value);
        emit OperationResult(result);
    }

    function remove(bytes32 value) public {
        bool result = _set.remove(value);
        emit OperationResult(result);
    }

    function length() public view returns (uint) {
        return _set.length();
    }

    function at(uint index) public view returns (bytes32) {
        return _set.at(index);
    }
}

// AddressSet
contract EnumerableAddressSetMock {
    using EnumerableSet for EnumerableSet.AddressSet;

    event OperationResult(bool result);

    EnumerableSet.AddressSet private _set;

    function contains(address value) public view returns (bool) {
        return _set.contains(value);
    }

    function add(address value) public {
        bool result = _set.add(value);
        emit OperationResult(result);
    }

    function remove(address value) public {
        bool result = _set.remove(value);
        emit OperationResult(result);
    }

    function length() public view returns (uint) {
        return _set.length();
    }

    function at(uint index) public view returns (address) {
        return _set.at(index);
    }
}

// UintSet
contract EnumerableUintSetMock {
    using EnumerableSet for EnumerableSet.UintSet;

    event OperationResult(bool result);

    EnumerableSet.UintSet private _set;

    function contains(uint value) public view returns (bool) {
        return _set.contains(value);
    }

    function add(uint value) public {
        bool result = _set.add(value);
        emit OperationResult(result);
    }

    function remove(uint value) public {
        bool result = _set.remove(value);
        emit OperationResult(result);
    }

    function length() public view returns (uint) {
        return _set.length();
    }

    function at(uint index) public view returns (uint) {
        return _set.at(index);
    }
}
