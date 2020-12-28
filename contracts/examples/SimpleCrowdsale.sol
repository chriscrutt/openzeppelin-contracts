// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "../GSN/Context.sol";
import "../token/ERC1618/ERC1618.sol";

/**
 * @title A pre-written token
 * @dev Very simple ERC1618 Token example, where all tokens are pre-
 * assigned to the creator.
 *
 * Note they can later distribute these tokens as they wish using
 * `transfer` and other `ERC1618` functions.
 */
contract Simple1618 is Context, Crowdsale {
    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor(uint256 tokens) ERC1618("SimpleToken", "SIM", 18) {
        _mint(_msgSender(), tokens * (10**uint256(decimals())));
    }
}
