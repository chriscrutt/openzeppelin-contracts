// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "./ERC201.sol";
import "../../access/roles/TrusteeRole.sol";

/**
 * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
 * which have permission to mint (create) new tokens as they see fit.
 *
 * At construction, the deployer of the contract is the only minter.
 */
abstract contract ERC201Mintable is ERC201, TrusteeRole {
    /**
     * @dev See {ERC20-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the {MinterRole}.
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
