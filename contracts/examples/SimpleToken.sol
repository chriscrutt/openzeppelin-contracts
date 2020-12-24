// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../GSN/Context.sol";
import "../token/ERC20/ERC20.sol";
import "../token/ERC20/ERC20Mintable.sol";

/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` functions.
 */
contract SimpleToken is Context, ERC20, ERC20Mintable {
    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor(uint tokens) ERC20("SimpleToken", "SIM") {
        _mint(_msgSender(), tokens * (10**uint256(decimals())));
    }
}