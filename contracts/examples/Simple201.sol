// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "../GSN/Context.sol";
import "../token/ERC201/ERC201.sol";
import "../token/ERC201/ERC201Mintable.sol";

/**
 * @title A pre-written token
 * @dev Very simple ERC201 Token example, where all tokens are pre-
 * assigned to the creator.
 *
 * Note they can later distribute these tokens as they wish using
 * `transfer` and other `ERC201` functions.
 */
contract SimpleToken is Context, ERC201, ERC201Mintable {
    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor(uint256 tokens) ERC201("SimpleToken", "SIM", 18) {
        _mint(_msgSender(), tokens * (10**uint256(decimals())));
    }
}
