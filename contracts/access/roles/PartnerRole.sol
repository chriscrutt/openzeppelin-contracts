// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../../utils/Context.sol";
import "../Roles.sol";

abstract contract PartnerRole is Context {
    using Roles for Roles.Role;

    event PartnerAdded(address indexed account);
    event PartnerRemoved(address indexed account);

    mapping(address => Roles.Role) private _authorized;

    modifier onlyPartner(address account) {
        require(
            isPartner(account, _msgSender()),
            "PartnerRole: caller does not have the Partner role"
        );
        _;
    }

    function isPartner(address account, address partner)
        public
        view
        returns (bool)
    {
        return _authorized[account].has(partner);
    }

    function addPartner(address account) public onlyPartner(account) {
        _addPartner(account);
    }

    function renouncePartner(address account) public {
        _removePartner(account);
    }

    function _addPartner(address account) internal {
        require(account != address(0), "partner cannot be 0 address");
        _authorized[_msgSender()].add(account);
        emit PartnerAdded(account);
    }

    function _removePartner(address account) internal {
        require(isPartner(_msgSender(), account), "not partner yet");
        require(_msgSender() != account, "you cannot remove youself");
        _authorized[_msgSender()].remove(account);
        emit PartnerRemoved(account);
    }
}
