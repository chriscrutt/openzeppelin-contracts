// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../access/roles/HolderRole.sol";
import "../GSN/Context.sol";
import "../token/ERC20/IERC20.sol";
import "../math/SafeMath.sol";

struct Holder {
    address holder;
    bool signed;
}

contract MultiSig is Context, HolderRole {
    using SafeMath for uint256;

    struct Transaction {
        uint256 amount;
        bool isEtherTransfer;
        IERC20 coinAddress;
        address sendTo;
        uint256 goodTillTime;
    }

    IERC20 private _coin;

    Transaction public transaction;

    uint256 private _signatureNum;

    Holder private _holder;

    Holder[] private _holders;

    event Signed(address);
    event Completed(address, Transaction);

    constructor(address[] memory holders) {
        for (uint256 i = 0; i < holders.length; i++) {
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
        require(amount > 0);
        require(sendTo != address(0));
        _initiateTransfer(
            amount,
            IERC20(coinAddress),
            sendTo,
            block.timestamp.add(10 minutes)
        );
    }

    function timeLeftSeconds() public view returns (uint256) {
        return _timeLeftSeconds();
    }

    function _timeLeftSeconds() private view returns (uint256) {
        Transaction storage t = transaction;
        uint256 time = t.goodTillTime;
        return time.sub(block.timestamp, "over time limit");
    }

    function completeTransfer(
        uint256 amount,
        address coinAddress,
        address sendTo
    ) public onlyHolder {
        require(_signatureNum > _holders.length.div(2), "over half must sign");
        require(amount == transaction.amount);
        require(coinAddress == address(transaction.coinAddress));
        require(sendTo == transaction.sendTo);
        require(_timeLeftSeconds() > 0);
        _completeTransfer(amount, IERC20(coinAddress), sendTo);
    }

    event Received(address, uint256);

    function _completeTransfer(
        uint256 _amount,
        IERC20 _coinAddress,
        address _sendTo
    ) private {
        for (uint256 i = 0; i < _holders.length; i++) {
            _holders[i].signed = false;
        }

        if (address(_coinAddress) == address(0)) {
            payable(_sendTo).transfer(_amount);
        } else {
            _coin = _coinAddress;
            _coin.transfer(_sendTo, _amount);
        }
        emit Completed(_msgSender(), transaction);
    }

    function sign() public onlyHolder {
        require(!_hasSigned(_msgSender()), "already signed");
        _sign(_msgSender());
    }

    function _getAccountNum(address _account) private view returns (uint8 i) {
        for (i = 0; i < _holders.length; i++) {
            if (_holders[i].holder == _account) {
                return i;
            }
        }
    }

    event Initialized(address, Transaction);


    function _sign(address _account) private {
        uint8 i = _getAccountNum(_account);
        _holders[i].signed = true;
        _signatureNum++;
        emit Signed(_account);
    }

    function numSigned() public view returns (uint256) {
        return _signatureNum;
    }

    function hasSigned(address account) public view returns (bool) {
        return _hasSigned(account);
    }

    function _hasSigned(address _account) private view returns (bool) {
        uint8 i = _getAccountNum(_account);
        return _holders[i].signed;
    }

    function _initiateTransfer(
        uint256 _amount,
        IERC20 _coinAddress,
        address _sendTo,
        uint256 _goodTillTime
    ) private {
        Transaction memory t = transaction;
        t.amount = _amount;
        t.coinAddress = _coinAddress;
        t.sendTo = _sendTo;
        t.goodTillTime = _goodTillTime;
        emit Initialized(_msgSender(), t);
    }
}
