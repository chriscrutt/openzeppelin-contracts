// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../../token/ERC1618/ERC1618.sol";
import "../../access/roles/TrusteeRole.sol";

/**
 * @dev Extension of {ERC1618} that adds a set of accounts with the
 * {TrusteeRole}, which have permission to mint (create) new tokens as
 * they see fit to anyone's account.
 *
 * At construction, the deployer of the contract is the only trustee.
 */
abstract contract ERC1618MintableOmniscient is ERC1618, TrusteeRole {
    /**
     * @dev See {ERC1618-_mint}.
     *
     * Requirements:
     * - the caller must have the {TrusteeRole}.
     *
     * @param account address to have their tokens minted
     * @param amount number of tokens to be minted
     * @return true if the tokens were successfully minted
     */
    function mint(address account, uint256 amount)
        public
        onlyTrustee
        returns (bool)
    {
        _mint(account, amount);
        return true;
    }
}
