// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../../utils/Context.sol";
import "../Roles.sol";

abstract contract TrusteeRole is Context {
    using Roles for Roles.Role;

    event TrusteeAdded(address indexed account);
    event TrusteeRemoved(address indexed account);

    Roles.Role private _trustees;

    address private _manager;

    constructor() {
        _addTrustee(_msgSender());
        _manager = _msgSender();
    }

    modifier onlyTrustee() {
        require(
            isTrustee(_msgSender()),
            "TrusteeRole: caller does not have the Trustee role"
        );
        _;
    }

    modifier onlyManager() {
        require(
            isManager(_msgSender()),
            "TrusteeRole: caller does not have the Manager role"
        );
        _;
    }

    function isTrustee(address account) public view returns (bool) {
        return _trustees.has(account);
    }

    function addTrustee(address account) public onlyTrustee {
        _addTrustee(account);
    }

    function renounceTrustee(address account) public {
        _removeTrustee(account);
    }

    function _addTrustee(address account) internal {
        _trustees.add(account);
        emit TrusteeAdded(account);
    }

    function _removeTrustee(address account) internal {
        require(!isManager(_msgSender()), "Cannot remove manager");

        require(_msgSender() == _manager || _msgSender() == account);
        _trustees.remove(account);
        emit TrusteeRemoved(account);
    }

    function isManager(address account) public view returns (bool) {
        return _manager == account;
    }

    function changeManager(address account) public {
        require(account != _manager, "Account is already manager");
        require(account != address(0), "Cannot set manager to Zero address");

        if (!isTrustee(account)) {
            _addTrustee(account);
        }

        _manager = account;
    }
}
