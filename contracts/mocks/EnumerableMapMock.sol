// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../utils/EnumerableMap.sol";

contract EnumerableMapMock {
    using EnumerableMap for EnumerableMap.UintToAddressMap;

    event OperationResult(bool result);

    EnumerableMap.UintToAddressMap private _map;

    function contains(uint key) public view returns (bool) {
        return _map.contains(key);
    }

    function set(uint key, address value) public {
        bool result = _map.set(key, value);
        emit OperationResult(result);
    }

    function remove(uint key) public {
        bool result = _map.remove(key);
        emit OperationResult(result);
    }

    function length() public view returns (uint) {
        return _map.length();
    }

    function at(uint index) public view returns (uint key, address value) {
        return _map.at(index);
    }


    function get(uint key) public view returns (address) {
        return _map.get(key);
    }
}
