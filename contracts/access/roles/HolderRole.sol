// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../../GSN/Context.sol";
import "../Roles.sol";

abstract contract HolderRole is Context {
    using Roles for Roles.Role;

    event HolderAdded(address indexed account);

    Roles.Role private _holders;

    modifier onlyHolder() {
        require(isHolder(_msgSender()), "HolderRole: are not Holder role");
        _;
    }

    function isHolder(address account) public view returns (bool) {
        return _holders.has(account);
    }

    function _addHolder(address account) internal {
        _holders.add(account);
        emit HolderAdded(account);
    }
}
