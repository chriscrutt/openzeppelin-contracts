// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../token/ERC20/ERC20.sol";

// mock class using ERC20
contract ERC20Mock is ERC20 {
    constructor (
        string memory name,
        string memory symbol,
        address initialAccount,
        uint initialBalance
    ) public payable ERC20(name, symbol) {
        _mint(initialAccount, initialBalance);
    }

    function mint(address account, uint amount) public {
        _mint(account, amount);
    }

    function burn(address account, uint amount) public {
        _burn(account, amount);
    }

    function transferInternal(address from, address to, uint value) public {
        _transfer(from, to, value);
    }

    function approveInternal(address owner, address spender, uint value) public {
        _approve(owner, spender, value);
    }
}
