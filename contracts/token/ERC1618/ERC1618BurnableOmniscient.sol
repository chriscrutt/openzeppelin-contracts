// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../../token/ERC201/ERC201.sol";
import "../../access/roles/TrusteeRole.sol";

/**
 * @dev Extension of {ERC201} that adds a set of accounts with the
 * {TrusteeRole}, which have permission to burn (destroy) new tokens as
 * they see fit from anyone's account.
 *
 * At construction, the deployer of the contract is the only trustee.
 */
abstract contract ERC201BurnableOmniscient is ERC201, TrusteeRole {
    /**
     * @dev See {ERC201-_burn}.
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
