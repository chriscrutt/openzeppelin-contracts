// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

/**
 * @dev Interface of the ERC1618 standard as defined in the EIP.
 */
interface IERC1618 {
    /**
     * @dev Emitted when `value` tokens are moved from one account
     * (`from`) to another (`to`).
     *
     * Note that `value` may be zero.
     *
     * @param from who transferred tokens
     * @param to who got the tokens
     * @param value number of tokens trasnferred
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Moves `amount` tokens from the caller's account to
     * `recipient`.
     *
     * Returns a boolean value indicating whether the operation
     * succeeded.
     *
     * Emits a {Transfer} event.
     *
     * @param recipient account to receive tokens
     * @param amount number of tokens to transfer
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     * @param account to get balance for
     */
    function balanceOf(address account) external view returns (uint256);
}
