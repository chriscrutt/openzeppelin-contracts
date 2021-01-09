// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../access/roles/HolderRole.sol";
import "../utils/Context.sol";
import "../token/ERC20/IERC20.sol";
import "../math/SafeMath.sol";

contract MultiSig is Context, HolderRole {
    using SafeMath for uint256;

    struct Holder {
        address holder;
        bool signed;
    }

    struct Transaction {
        uint256 amount;
        address coinAddress;
        address sendTo;
        uint256 goodTillTime;
    }

    Holder private _holder;
    Holder[] private _holders;

    Transaction private _transaction;

    IERC20 private _coin;

    uint256 private _signatureNum;

    event Initialized(address, Transaction);
    event Signed(address);
    event Completed(address, Transaction);
    event Received(address, uint256);

    constructor(address[] memory holders) {
        Holder memory h = _holder;
        for (uint256 i = 0; i < holders.length; i++) {
            require(holders[i] != address(0), "0 address can't be a holder");
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
        require(amount > 0, "transfer amount can't be zero");
        require(sendTo != address(0), "can't send to 0 address");
        // if (coinAddress == address(0)) {
        //     _initiateTransfer(
        //         amount,
        //         coinAddress,
        //         sendTo,
        //         block.timestamp.add(10 minutes)
        //     );
        // }

        _initiateTransfer(
            amount,
            IERC20(coinAddress),
            sendTo,
            block.timestamp.add(10 minutes)
        );
    }

    function sign() public onlyHolder {
        require(!_hasSigned(_msgSender()), "already signed");
        _sign(_msgSender());
    }

    function completeTransfer(
        uint256 amount,
        address coinAddress,
        address sendTo
    ) public onlyHolder {
        Transaction memory t = _transaction;
        require(_signatureNum > _holders.length.div(2), "over half must sign");
        require(amount == t.amount, "amounts not equal");
        require(
            coinAddress == address(t.coinAddress),
            "coin addresses not equal"
        );
        require(sendTo == t.sendTo, "recipient address not equal");
        require(_timeLeftSeconds() > 0, "time is up! restart sorry");
        _completeTransfer(amount, IERC20(coinAddress), sendTo);
    }

    function currentTransaction() public view returns (Transaction memory) {
        return _transaction;
    }

    function hasSigned(address account) public view returns (bool) {
        return _hasSigned(account);
    }

    function numSigned() public view returns (uint256) {
        return _signatureNum;
    }

    function timeLeftSeconds() public view returns (uint256) {
        return _timeLeftSeconds();
    }

    function _initiateTransfer(
        uint256 _amount,
        IERC20 _coinAddress,
        address _sendTo,
        uint256 _goodTillTime
    ) private {
        Transaction memory t = _transaction;
        t.amount = _amount;
        t.coinAddress = address(_coinAddress);
        t.sendTo = _sendTo;
        t.goodTillTime = _goodTillTime;
        _transaction = t;
        emit Initialized(_msgSender(), t);
    }

    function _sign(address _account) private {
        uint8 i = _getAccountNum(_account);
        _holders[i].signed = true;
        _signatureNum++;
        emit Signed(_account);
    }

    function _completeTransfer(
        uint256 _amount,
        IERC20 _coinAddress,
        address _sendTo
    ) private {
        Holder[] memory _h = _holders;
        for (uint256 i = 0; i < _h.length; i++) {
            _h[i].signed = false;
        }

        if (address(_coinAddress) == address(0)) {
            payable(_sendTo).transfer(_amount);
        } else {
            _coin = _coinAddress;
            _coin.transfer(_sendTo, _amount);
        }
        emit Completed(_msgSender(), _transaction);
    }

    function _getAccountNum(address _account) private view returns (uint8 i) {
        Holder[] memory _h = _holders;
        for (i = 0; i < _h.length; i++) {
            if (_h[i].holder == _account) {
                return i;
            }
        }
    }

    function _hasSigned(address _account) private view returns (bool) {
        uint8 i = _getAccountNum(_account);
        return _holders[i].signed;
    }

    function _timeLeftSeconds() private view returns (uint256) {
        Transaction storage t = _transaction;
        uint256 time = t.goodTillTime;
        return time.sub(block.timestamp, "over time limit");
    }
}