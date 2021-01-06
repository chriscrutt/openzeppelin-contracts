// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../../GSN/Context.sol";
import "../Roles.sol";

abstract contract HolderRole is Context {
    using Roles for Roles.Role;

    event HolderAdded(address indexed account);
    // event HolderRemoved(address indexed account);

    Roles.Role private _holders;

    // address private _manager;

    // constructor() {
        // _addHolder(_msgSender());
        // _manager = _msgSender();
    // }

    modifier onlyHolder() {
        require(
            isHolder(_msgSender()),
            "HolderRole: caller does not have the Holder role"
        );
        _;
    }

    // modifier onlyManager() {
    //     require(
    //         isManager(_msgSender()),
    //         "HolderRole: caller does not have the Manager role"
    //     );
    //     _;
    // }

    function isHolder(address account) public view returns (bool) {
        return _holders.has(account);
    }

    // function addHolder(address account) public onlyHolder {
    //     _addHolder(account);
    // }

    // function renounceHolder(address account) public {
    //     _removeHolder(account);
    // }

    function _addHolder(address account) internal {
        _holders.add(account);
        emit HolderAdded(account);
    }

    // function _removeHolder(address account) internal {
    //     require(!isManager(_msgSender()), "Cannot remove manager");

    //     require(_msgSender() == _manager || _msgSender() == account);
    //     _holders.remove(account);
    //     emit HolderRemoved(account);
    // }

    // function isManager(address account) public view returns (bool) {
    //     return _manager == account;
    // }

    // function changeManager(address account) public {
    //     require(account != _manager, "Account is already manager");
    //     require(account != address(0), "Cannot set manager to Zero address");

    //     if (!isHolder(account)) {
    //         _addHolder(account);
    //     }

    //     _manager = account;
    // }
}
