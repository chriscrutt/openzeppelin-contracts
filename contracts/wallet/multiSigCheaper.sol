// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../utils/Context.sol";
import "../token/ERC20/IERC20.sol";
import "../math/SafeMath.sol";

contract MultiSigCheaper is Context {
    using SafeMath for uint256;

    struct Transaction {
        uint256 amount;
        IERC20 coinAddress;
        address sendTo;
        uint256 goodTillTime;
    }

    uint8 public numberHolders;
    uint8 public signatureNum;
    address public owner;
    mapping(address => uint256) public holderSignTime;
    Transaction public transaction;

    event Initialized(address indexed, Transaction);
    event Signed(address indexed);
    event Completed(address indexed, Transaction);
    event Received(address indexed, uint256);

    constructor() {
        owner = _msgSender();
        _addHolder(_msgSender());
    }

    receive() external payable {
        emit Received(_msgSender(), msg.value);
    }

    function replaceOwner(address newOwner) public {
        require(_msgSender() == owner, "not current owner");

        owner = newOwner;
    }

    function isHolder(address holder) public view returns (bool) {
        return holderSignTime[holder] > 0;
    }

    function addHolder(address account) public {
        require(!isHolder(account), "account already holder");
        require(_msgSender() == owner, "not owner");
        require(account != address(0), "0 address can't be a holder");

        _addHolder(account);
    }

    function removeHolder(address account) public {
        require(_msgSender() == owner, "not owner");
        require(isHolder(account), "account already isn't holder");

        _removeHolder(account);
    }

    function initiateTransfer(uint256 amount, address sendTo) public {
        require(amount > 0, "transfer amount can't be zero");
        require(sendTo != address(0), "can't send to 0 address");
        require(isHolder(_msgSender()), "not a holder, jerk");
        require(
            block.timestamp > transaction.goodTillTime,
            "wait for old transaction"
        );
        require(address(this).balance >= amount, "not enough balance");

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
        require(amount > 0, "transfer amount can't be zero");
        require(sendTo != address(0), "can't send to 0 address");
        require(isHolder(_msgSender()), "not a holder, jerk");
        require(
            block.timestamp > transaction.goodTillTime,
            "wait for old transaction"
        );
        require(
            IERC20(coinAddressIfApplicable).balanceOf(address(this)) >= amount,
            "not enough balance"
        );

        _initiateTransfer(
            amount,
            coinAddressIfApplicable,
            sendTo,
            block.timestamp.add(10 minutes)
        );
    }

    function sign() public {
        require(isHolder(_msgSender()), "not a holder, jerk");
        require(!_hasSigned(_msgSender()), "already signed");

        _sign(_msgSender());
    }

    function completeTransfer(uint256 amount, address sendTo) public {
        require(isHolder(_msgSender()), "not a holder, jerk");
        require(signatureNum > numberHolders / 2, "over half must sign");

        Transaction memory t = transaction;

        require(amount == t.amount, "amounts not equal");
        require(sendTo == t.sendTo, "recipient address not equal");

        _completeTransfer(amount, t.coinAddress, sendTo);
    }

    function hasSigned(address account) public view returns (bool) {
        return _hasSigned(account);
    }

    function timeLeftSeconds() public view returns (uint256) {
        Transaction memory t = transaction;
        return t.goodTillTime.sub(block.timestamp, "over time limit");
    }

    function _addHolder(address _account) private {
        numberHolders++;
        holderSignTime[_account] = block.timestamp;
    }

    function _removeHolder(address _account) private {
        delete holderSignTime[_account];
        numberHolders--;
    }

    function _initiateTransfer(
        uint256 _amount,
        address _coinAddress,
        address _sendTo,
        uint256 _goodTillTime
    ) private {
        Transaction storage t = transaction;
        t.amount = _amount;
        if (_coinAddress != address(0)) {
            t.coinAddress = IERC20(_coinAddress);
        }
        t.sendTo = _sendTo;
        t.goodTillTime = _goodTillTime;
        emit Initialized(_msgSender(), t);
    }

    function _hasSigned(address _account) private view returns (bool) {
        Transaction memory t = transaction;

        return
            t.goodTillTime - 10 minutes <= holderSignTime[_account] &&
            holderSignTime[_account] <= t.goodTillTime;
    }

    function _sign(address _account) private {
        holderSignTime[_account] = block.timestamp;
        signatureNum++;
        emit Signed(_account);
    }

    function _completeTransfer(
        uint256 _amount,
        IERC20 _coinAddress,
        address _sendTo
    ) private {
        delete signatureNum;
        Transaction memory t = transaction;
        delete transaction;

        if (address(_coinAddress) == address(0)) {
            payable(_sendTo).transfer(_amount);
        } else {
            IERC20 _coin = _coinAddress;
            _coin.transfer(_sendTo, _amount);
        }

        emit Completed(_msgSender(), t);
    }
}
