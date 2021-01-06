// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

contract DelMath {
    function isCoin(address addr) public view returns (bool) {
        uint32 size;
        if (addr == address(0)) {
            size == 1;
        } else {
            assembly {
                size := extcodesize(addr)
            }
        }
        return (size > 0);
    }

    function divv(uint256 one, uint256 two) public pure returns (uint256) {
        return one / two;
    }
}

// 0xB5e85578737F413fAF5aeEf8f358B78CEb89fF76,0x8b1A1aF63bb9b3730f62c56bDa272BCC69dF4CC7,0x90F78371BA78B0Efeb49468368F34b70B0baE9d6,0x0746Ec11950d12752587081B38d7Bd10388dE0E6
// 0x8b1A1aF63bb9b3730f62c56bDa272BCC69dF4CC7
// 0x0000000000000000000000000000000000000000
// 1000000000000000000