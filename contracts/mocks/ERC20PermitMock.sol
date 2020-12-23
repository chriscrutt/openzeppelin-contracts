// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../drafts/ERC20Permit.sol";

contract ERC20PermitMock is ERC20Permit {
    constructor (
        string memory name,
        string memory symbol,
        address initialAccount,
        uint256 initialBalance
    ) public payable ERC20(name, symbol) ERC20Permit(name) {
        _mint(initialAccount, initialBalance);
    }

    function getChainId() external view returns (uint256 chainId) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        // solhint-disable-next-line no-inline-assembly
        assembly {
            chainId := chainid()
        }
    }
}
