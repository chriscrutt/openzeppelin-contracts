// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../utils/Context.sol";
import "../token/ERC20/IERC20.sol";
import "../math/SafeMath.sol";

contract MultiSig is Context {
    using SafeMath for uint256;

    struct Transaction {
        uint256 amount;
        IERC20 coinAddress;
        address sendTo;
        uint256 goodTillTime;
    }

    mapping(address => uint256) private _holderSignTime;

    address private _owner;

    Transaction private _transaction;

    IERC20 private _coin;

    uint8 private _numberHolders;
    uint8 private _signatureNum;

    event Initialized(address indexed, Transaction);
    event Signed(address indexed);
    event Completed(address indexed, Transaction);
    event Received(address indexed, uint256);

    constructor() {
        _owner = _msgSender();
        _addHolder(_msgSender());
    }

    receive() external payable {
        emit Received(_msgSender(), msg.value);
    }

    function isOwner() public view returns (address) {
        return _owner;
    }

    function replaceOwner(address newOwner) public {
        require(_msgSender() == _owner, "not current owner");

        _owner = newOwner;
    }

    function isHolder(address holder) public view returns (bool) {
        return _holderSignTime[holder] > 0;
    }

    function addHolder(address account) public {
        require(!isHolder(account), "account already holder");
        require(_msgSender() == _owner, "not owner");
        require(account != address(0), "0 address can't be a holder");

        _addHolder(account);
    }

    function removeHolder(address account) public {
        require(_msgSender() == _owner, "not owner");
        require(isHolder(account), "account already isn't holder");

        _removeHolder(account);
    }

    function initiateTransfer(uint256 amount, address sendTo) public {
        require(amount > 0, "transfer amount can't be zero");
        require(sendTo != address(0), "can't send to 0 address");
        require(isHolder(_msgSender()), "not a holder, jerk");
        require(
            block.timestamp > _transaction.goodTillTime,
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
            block.timestamp > _transaction.goodTillTime,
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
        require(_signatureNum > _numberHolders / 2, "over half must sign");

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
        return _hasSigned(account);
    }

    function numSigned() public view returns (uint8) {
        return _signatureNum;
    }

    function numHolders() public view returns (uint8) {
        return _numberHolders;
    }

    function timeLeftSeconds() public view returns (uint256) {
        return _timeLeftSeconds();
    }

    function _addHolder(address _account) private {
        _numberHolders++;
        _holderSignTime[_account] = block.timestamp;
    }

    function _removeHolder(address _account) private {
        delete _holderSignTime[_account];
        _numberHolders--;
    }

    function _initiateTransfer(
        uint256 _amount,
        address _coinAddress,
        address _sendTo,
        uint256 _goodTillTime
    ) private {
        Transaction storage t = _transaction;
        t.amount = _amount;
        if (_coinAddress != address(0)) {
            t.coinAddress = IERC20(_coinAddress);
        }
        t.sendTo = _sendTo;
        t.goodTillTime = _goodTillTime;
        emit Initialized(_msgSender(), t);
    }

    function _hasSigned(address _account) private view returns (bool) {
        Transaction memory t = _transaction;

        return
            t.goodTillTime - 10 minutes <= _holderSignTime[_account] &&
            _holderSignTime[_account] <= t.goodTillTime;
    }

    function _sign(address _account) private {
        _holderSignTime[_account] = block.timestamp;
        _signatureNum++;
        emit Signed(_account);
    }

    function _timeLeftSeconds() private view returns (uint256) {
        Transaction memory t = _transaction;
        return t.goodTillTime.sub(block.timestamp, "over time limit");
    }

    function _completeTransfer(
        uint256 _amount,
        IERC20 _coinAddress,
        address _sendTo
    ) private {
        delete _signatureNum;
        Transaction memory t = _transaction;
        delete _transaction;

        if (address(_coinAddress) == address(0)) {
            payable(_sendTo).transfer(_amount);
        } else {
            _coin = _coinAddress;
            _coin.transfer(_sendTo, _amount);
        }

        emit Completed(_msgSender(), t);
    }
}
