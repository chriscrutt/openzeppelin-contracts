// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "./IERC777.sol";
import "../../math/SafeMath.sol";
import "../../utils/Address.sol";

/**
 * @title SafeERC777
 * @dev Wrappers around ERC777 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC777 for IERC777;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC777 {
    using SafeMath for uint256;
    using Address for address;

    function safeSend(
        IERC777 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.send.selector, to, value)
        );
    }

    function safeOperatorSend(
        IERC777 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.operatorSend.selector,
                from,
                to,
                value
            )
        );
    }

    function safeAuthorizeOperator(IERC777 token, address operator) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.authorizeOperator.selector, operator)
        );
    }

    function safeRevokeOperator(IERC777 token, address operator) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.revokeOperator.selector, operator)
        );
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC777 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata =
            address(token).functionCall(
                data,
                "SafeERC777: low-level call failed"
            );
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC777: ERC777 operation did not succeed"
            );
        }
    }
}
