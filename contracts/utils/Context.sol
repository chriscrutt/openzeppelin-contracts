// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

/**
 * @title gives... context for contract interations!
 * @notice simplifies looking up the address interacting with a contract
 * as well as the information being transimtted
 * @dev Provides information about the current execution context,
 * including the sender of the transaction and its data. While these are
 * generally available via msg.sender and msg.data, they should not be
 * accessed in such a direct manner, since when dealing with GSN
 * meta-transactions the account sending and paying for execution may
 * not be the actual sender (as far as an application is concerned).
 *
 * This contract is only required for intermediate library-like contract
 */
abstract contract Context {
    /**
     * @notice gets address interacting with contract
     * @return that address
     */
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    /**
     * @notice gets information being used to interact with the contract
     * @dev silence state mutability warning without generating bytecode
     * with `this;` - https://github.com/ethereum/solidity/issues/2691
     * @return that information
     */
    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}
