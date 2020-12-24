// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../GSN/Context.sol";
import "../token/ERC20/ERC20_1Legit.sol";
import "../token/ERC20/MintableERC20_1Legit.sol";

/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` functions.
 */
contract SimpleLegitToken is Context, ERC20_1Legit, MintableERC20_1L {
    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor(uint tokens) ERC20_1Legit("SimpleLegitToken", "SLG", 18) {
        _mint(_msgSender(), tokens * (10**uint256(decimals())));
    }
}
