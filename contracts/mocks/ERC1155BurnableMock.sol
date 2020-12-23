// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../token/ERC1155/ERC1155Burnable.sol";

contract ERC1155BurnableMock is ERC1155Burnable {
    constructor(string memory uri) public ERC1155(uri) { }

    function mint(address to, uint id, uint value, bytes memory data) public {
        _mint(to, id, value, data);
    }
}
