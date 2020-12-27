// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../../token/ERC1618/ERC1618.sol";
import "../../access/roles/TrusteeRole.sol";

/**
 * @dev Extension of {ERC1618} that adds a set of accounts with the
 * {TrusteeRole}, which have permission to burn (destroy) new tokens as
 * they see fit from anyone's account.
 *
 * At construction, the deployer of the contract is the only trustee.
 */
abstract contract ERC1618BurnableOmniscient is ERC1618, TrusteeRole {
    /**
     * @dev See {ERC1618-_burn}.
     *
     * Requirements:
     *
     * - the caller must have the {TrusteeRole}.
     *
     * @param account address to have their tokens burned
     * @param amount number of tokens to be burned from msg.sender
     *
     * @return true if the tokens were successfully burned
     */
    function burn(address account, uint256 amount)
        public
        onlyTrustee
        returns (bool)
    {
        _burn(account, amount);
        return true;
    }
}
