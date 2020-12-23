// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../GSN/Context.sol";
import "../token/ERC777/ERC777.sol";

contract ERC777Mock is Context, ERC777 {
    constructor(
        address initialHolder,
        uint initialBalance,
        string memory name,
        string memory symbol,
        address[] memory defaultOperators
    ) public ERC777(name, symbol, defaultOperators) {
        _mint(initialHolder, initialBalance, "", "");
    }

    function mintInternal (
        address to,
        uint amount,
        bytes memory userData,
        bytes memory operatorData
    ) public {
        _mint(to, amount, userData, operatorData);
    }

    function approveInternal(address holder, address spender, uint value) public {
        _approve(holder, spender, value);
    }
}
