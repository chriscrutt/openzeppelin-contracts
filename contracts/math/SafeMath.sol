// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

/**
 * @title makes sure math did done right doggonnit
 *
 * @dev Wrappers over Solidity's arithmetic operations with added
 * overflow checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily
 * result in bugs, because programmers usually assume that an overflow
 * raises an error, which is the standard behavior in high level
 * programming languages. `SafeMath` restores this intuition by
 * reverting the transaction when an operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an
 * entire class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @notice Returns the addition of two unsigned integers, reverting
     * on overflow.
     *
     * @dev Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     *
     * @param a first uint
     * @param b second uint
     * @return add `a` with `b`
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @notice Returns the subtraction of two unsigned integers,
     * reverting on overflow (when the result is negative).
     *
     * @dev Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * @param a first uint
     * @param b second uint
     * @return subtract 'a' with `b`
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @notice Returns the subtraction of two unsigned integers,
     * reverting on overflow (when the result is negative).
     *
     * @dev Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * @param a first uint
     * @param b second uint
     * @return subtract `a` with `b`
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @notice Returns the multiplication of two unsigned integers,
     * reverting on overflow.
     *
     * @dev Counterpart to Solidity's `*` operator.
     *
     * Gas optimization: this is cheaper than requiring 'a' not being
     * zero, but the benefit is lost if 'b' is also tested.
     * https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
     *
     * Requirements:
     * - Multiplication cannot overflow.
     *
     * @param a first uint
     * @param b second uint
     * @return multiple `a` with `b`
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiply overflow");

        return c;
    }

    /**
     * @notice Returns the integer division of two unsigned integers.
     * Reverts on division by zero. The result is rounded towards zero.
     *
     * @dev Counterpart to Solidity's `/` operator. Note: this function
     * uses a `revert` opcode (which leaves remaining gas untouched)
     * while Solidity uses an invalid opcode to revert (consuming all
     * remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * @param a first uint
     * @param b second uint
     * @return divide `a` with `b`
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @notice Returns the integer division of two unsigned integers.
     * Reverts with custom message on division by zero. The result is
     * rounded towards zero.
     *
     * @dev Counterpart to Solidity's `/` operator. Note: this function
     * uses a `revert` opcode (which leaves remaining gas untouched)
     * while Solidity uses an invalid opcode to revert (consuming all
     * remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * @param a first uint
     * @param b second uint
     * @return divide `a` with `b`
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    /**
     * @notice Returns the remainder of dividing two unsigned integers.
     * (unsigned integer modulo), Reverts when dividing by zero.
     *
     * @dev Counterpart to Solidity's `%` operator. This function uses a
     * `revert` opcode (which leaves remaining gas untouched) while
     * Solidity uses an invalid opcode to revert (consuming all
     * remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * @param a first uint
     * @param b second uint
     * @return modular of `a` / `b`
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @notice Returns the remainder of dividing two unsigned integers.
     * (unsigned integer modulo), Reverts with custom message when
     * dividing by zero.
     *
     * @dev Counterpart to Solidity's `%` operator. This function uses a
     * `revert` opcode (which leaves remaining gas untouched) while
     * Solidity uses an invalid opcode to revert (consuming all
     * remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * @param a first uint
     * @param b second uint
     * @return modular of `a` / `b`
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

    /**
     * @dev Division, round to nearest integer (AKA round-half-up)
     * @param a What to divide
     * @param b Divide by this number
     */
    function roundedDiv(int256 a, int256 b) internal pure returns (int256) {
        // Solidity automatically throws, but please emit reason
        require(b > 0, "div by 0");

        int256 halfB = (b % 2 == 0) ? (b / 2) : (b / 2 + 1);
        return (a % b >= halfB) ? (a / b + 1) : (a / b);
    }
}
