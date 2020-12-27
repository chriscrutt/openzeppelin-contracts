// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../../token/ERC201/ERC201.sol";
import "../../access/roles/TrusteeRole.sol";

/**
 * @dev Extension of {ERC201} that adds a set of accounts with the
 * {TrusteeRole}, which have permission to mint (create) new tokens as
 * they see fit to anyone's account.
 *
 * At construction, the deployer of the contract is the only trustee.
 */
abstract contract ERC201MintableOmniscient is ERC201, TrusteeRole {
    /**
     * @dev See {ERC201-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the {TrusteeRole}.
     *
     * @param account address to have their tokens minted 
     * @param amount number of tokens to be minted to msg.sender
     *
     * @return true if the tokens were successfully minted
     */
    function mint(address account, uint256 amount) public onlyTrustee returns (bool) {
        _mint(account, amount);
        return true;
    }
}
