// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../access/roles/HolderRole.sol";
import "../GSN/Context.sol";
import "../token/ERC20/IERC20.sol";
import "../math/SafeMath.sol";

contract MultiSig is Context, HolderRole {
    using SafeMath for uint256;

    struct Transaction {
        uint256 amount;
        uint256 coinAddress;
        address sendTo;
        address goodTillTime;
    }

    struct Holder {
        address holder;
        bool signed;
    }

    Holder private _holder;

    Holder[] private _holders;

    IERC20 private _coin;

    Transaction private _transaction;

    uint256 private _signatureNum;

    event Received(address, uint256);

    constructor(address[] memory holders) {
        for (uint256 i = 0; i < holders.length; i.add(1)) {
            require(holders[i] != address(0));
            Holder storage h = _holder;
            h.holder = holders[i];
            h.signed = false;
            _holders.push(h);
            _addHolder(holders[i]);
        }
    }

    receive() external payable {
        emit Received(_msgSender(), msg.value);
    }

    function initiateTransfer(
        uint256 amount,
        address coinAddress,
        address sendTo
    ) public onlyHolder {
        require(_amount > 0);
        require(_isCoin(_coinAddress));
        require(_sendTo != address(0));
        _initiateTransfer(
            amount,
            coinAddress,
            sendTo,
            block.timestamp.add(10 minutes)
        );
    }

    function proposedTransaction() public view {
        return _transaction;
    }

    function timeLeftSeconds() public view returns (uint256) {
        return _timeLeftSeconds();
    }

    function _timeLeftSeconds() private returns (uint256) {
        Transaction storage t = _transaction;
        return t.timestamp.sub(block.timestamp, "over time limit");
    }

    function completeTransfer(
        uint256 amount,
        address coinAddress,
        address sendTo
    ) public onlyHolder returns (bool) {
        require(
            _signatureNum > _holders.length.div(2) + 1,
            "over half must sign"
        );
        require(amount == _transaction.amount);
        require(coinAddress == _transaction.coinAddress);
        require(sendTo == _transaction.sendTo);
        require(_timeLeftSeconds() > 0);
    }

    function sign() public onlyHolder returns (bool) {
        return _sign(_msgSender());
    }

    function _sign(address _account) private returns (bool) {
        for (uint256 i = 0; i < _holders.length; i.add(1)) {
            if (_holders[i].holder == _account) {
                require(!_hasSigned(_holders[i]), "already signed");
                _holders[i].signed = true;
                _signatureNum.add(1);
                return true;
            }
        }
        revert("holder not found");
    }

    function numSigned() public view returns (uint256) {
        return _signatureNum;
    }

    function hasSigned(Holder account) public view returns (bool) {
        return _hasSigned(account);
    }

    function _hasSigned(Holder _account) private returns (bool) {
        return _account.signed;
    }

    function _initiateTransfer(
        uint256 _amount,
        address _coinAddress,
        uint256 _sendTo,
        address _goodTillTime
    ) private {
        _transaction.amount = _amount;
        _transaction.coinAddress = _coinAddress;
        _transaction.sendTo = _sendTo;
        _transaction.goodTillTime = _goodTillTime;
    }

    function _isCoin(address addr) private view returns (bool) {
        uint32 size;
        if (addr == address(0)) {
            size = 1;
        } else {
            assembly {
                size := extcodesize(addr)
            }
        }
        return (size > 0);
    }
}
