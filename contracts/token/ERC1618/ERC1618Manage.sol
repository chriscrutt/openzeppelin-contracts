// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../../token/ERC1618/ERC1618.sol";
import "../../access/roles/PartnerRole.sol";

/**
 * @dev Extension of {ERC1618} that adds a set of accounts with the
 * {TrusteeRole}, which have permission to burn (destroy) new tokens as
 * they see fit from anyone's account.
 *
 * At construction, the deployer of the contract is the only trustee.
 */
abstract contract ERC1618Manage is ERC1618, PartnerRole {
    function transferOnBehalf(
        address sender,
        address recipient,
        uint256 amount
    ) public onlyPartner(sender) returns (bool) {
        _transfer(sender, recipient, amount);
        return true;
    }
}
