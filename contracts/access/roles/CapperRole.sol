// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../../utils/Context.sol";
import "../Roles.sol";

abstract contract CapperRole is Context {
    using Roles for Roles.Role;

    event CapperAdded(address indexed account);
    event CapperRemoved(address indexed account);

    Roles.Role private _cappers;

    constructor() {
        _addCapper(_msgSender());
    }

    modifier onlyCapper() {
        require(
            isCapper(_msgSender()),
            "CapperRole: caller does not have the Capper role"
        );
        _;
    }

    function isCapper(address account) public view returns (bool) {
        return _cappers.has(account);
    }

    function addCapper(address account) public onlyCapper {
        _addCapper(account);
    }

    function renounceCapper() public {
        _removeCapper(_msgSender());
    }

    function _addCapper(address account) internal {
        _cappers.add(account);
        emit CapperAdded(account);
    }

    function _removeCapper(address account) internal {
        _cappers.remove(account);
        emit CapperRemoved(account);
    }
}
