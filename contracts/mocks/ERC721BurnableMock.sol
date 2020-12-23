// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../token/ERC721/ERC721Burnable.sol";

contract ERC721BurnableMock is ERC721Burnable {
    constructor(string memory name, string memory symbol) public ERC721(name, symbol) { }

    function mint(address to, uint tokenId) public {
        _mint(to, tokenId);
    }
}
