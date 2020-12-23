// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../token/ERC1155/IERC1155Receiver.sol";
import "./ERC165Mock.sol";

contract ERC1155ReceiverMock is IERC1155Receiver, ERC165Mock {
    bytes4 private _recRetval;
    bool private _recReverts;
    bytes4 private _batRetval;
    bool private _batReverts;

    event Received(address operator, address from, uint id, uint value, bytes data, uint gas);
    event BatchReceived(address operator, address from, uint[] ids, uint[] values, bytes data, uint gas);

    constructor (
        bytes4 recRetval,
        bool recReverts,
        bytes4 batRetval,
        bool batReverts
    )
        public
    {
        _recRetval = recRetval;
        _recReverts = recReverts;
        _batRetval = batRetval;
        _batReverts = batReverts;
    }

    function onERC1155Received(
        address operator,
        address from,
        uint id,
        uint value,
        bytes calldata data
    )
        external
        override
        returns(bytes4)
    {
        require(!_recReverts, "ERC1155ReceiverMock: reverting on receive");
        emit Received(operator, from, id, value, data, gasleft());
        return _recRetval;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint[] calldata ids,
        uint[] calldata values,
        bytes calldata data
    )
        external
        override
        returns(bytes4)
    {
        require(!_batReverts, "ERC1155ReceiverMock: reverting on batch receive");
        emit BatchReceived(operator, from, ids, values, data, gasleft());
        return _batRetval;
    }
}
