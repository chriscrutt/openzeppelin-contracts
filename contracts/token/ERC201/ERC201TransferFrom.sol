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
abstract contract ERC201TransferFrom is ERC201, TrusteeRole {
    /**
     * @dev See {ERC201-_transfer}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     *
     * @param sender address to transfer token
     * @param recipient address to receive token
     * @param amount number of tokens to be transferred
     *
     * @return true is transfer succeeded
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public onlyTrustee returns (bool) {
        require(!isTrustee(sender));
        _transfer(sender, recipient, amount);
        return true;
    }

    /**
     * @dev See {ERC201-_transfer}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     *
     * @param sender address to transfer token
     * @param recipient address to receive token
     * @param amount number of tokens to be transferred
     *
     * @return true is transfer succeeded
     */
    function transferFromTrustee(
        address sender,
        address recipient,
        uint256 amount
    ) public onlyManager returns (bool) {
        _transfer(sender, recipient, amount);
        return true;
    }
}
