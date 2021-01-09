// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../utils/Context.sol";
import "../token/ERC20/IERC20.sol";
import "../math/SafeMath.sol";

contract MultiSigCopy is Context {
    using SafeMath for uint256;

    mapping(address => bool) private _signed;

    struct Transaction {
        uint256 amount;
        IERC20 coinAddress;
        address sendTo;
        uint256 goodTillTime;
    }

    Transaction private _transaction;

    IERC20 private _coin;

    event Initialized(address, Transaction);
    event Signed(address);
    event Completed(address, Transaction);
    event Received(address, uint256);

    constructor() {
        _signed[_msgSender()] = false;
    }

    receive() external payable {
        emit Received(_msgSender(), msg.value);
    }

    function initiateTransfer(uint256 amount, address sendTo) public {
        require(
            _signed[_msgSender()] || !_signed[_msgSender()],
            "not an owner"
        );
        require(amount > 0, "transfer amount can't be zero");
        require(sendTo != address(0), "can't send to 0 address");

        _initiateTransfer(
            amount,
            address(0),
            sendTo,
            block.timestamp.add(10 minutes)
        );
    }

    function initiateTransfer(
        uint256 amount,
        address sendTo,
        address coinAddressIfApplicable
    ) public {
        require(
            _signed[_msgSender()] || !_signed[_msgSender()],
            "not an owner"
        );
        require(amount > 0, "transfer amount can't be zero");
        require(sendTo != address(0), "can't send to 0 address");

        _initiateTransfer(
            amount,
            coinAddressIfApplicable,
            sendTo,
            block.timestamp.add(10 minutes)
        );
    }

    function sign() public {
        require(!_signed[_msgSender()], "already signed");
        _sign(_msgSender());
    }

    function completeTransfer(uint256 amount, address sendTo) public {
        require(_signed[_msgSender()], "not signed");
        Transaction memory t = _transaction;
        require(amount == t.amount, "amounts not equal");

        require(sendTo == t.sendTo, "recipient address not equal");
        require(_timeLeftSeconds() > 0, "time is up! restart sorry");
        _completeTransfer(amount, t.coinAddress, sendTo);
    }

    function currentTransaction() public view returns (Transaction memory) {
        return _transaction;
    }

    function hasSigned(address account) public view returns (bool) {
        return _signed[account];
    }

    function timeLeftSeconds() public view returns (uint256) {
        return _timeLeftSeconds();
    }

    function _initiateTransfer(
        uint256 _amount,
        address _coinAddress,
        address _sendTo,
        uint256 _goodTillTime
    ) private {
        Transaction memory t = _transaction;
        t.amount = _amount;
        if (_coinAddress != address(0)) {
            t.coinAddress = IERC20(_coinAddress);
        }
        t.sendTo = _sendTo;
        t.goodTillTime = _goodTillTime;
        // _transaction = t;
        emit Initialized(_msgSender(), t);
    }

    function _sign(address _account) private {
        _signed[_account] = true;
        emit Signed(_account);
    }

    function _completeTransfer(
        uint256 _amount,
        IERC20 _coinAddress,
        address _sendTo
    ) private {
        _transaction.goodTillTime = 0;

        if (address(_coinAddress) == address(0)) {
            payable(_sendTo).transfer(_amount);
        } else {
            _coin = _coinAddress;
            _coin.transfer(_sendTo, _amount);
        }
        _signed[_msgSender()] = false;
        emit Completed(_msgSender(), _transaction);
    }

    function _timeLeftSeconds() private view returns (uint256) {
        Transaction storage t = _transaction;
        uint256 time = t.goodTillTime;
        return time.sub(block.timestamp, "over time limit");
    }
}
