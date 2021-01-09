// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../access/roles/HolderRole.sol";
import "../utils/Context.sol";
import "../token/ERC20/IERC20.sol";
import "../math/SafeMath.sol";

contract MultiSigCopy is Context, HolderRole {
    using SafeMath for uint256;

    struct Holder {
        address holder;
        bool signed;
    }

    struct Transaction {
        uint256 amount;
        IERC20 coinAddress;
        address sendTo;
        uint256 goodTillTime;
    }

    address private _owner;

    Holder private _holder;

    Transaction private _transaction;

    IERC20 private _coin;

    Holder[] private _holders;

    uint8 private _signatureNum;

    event Initialized(address indexed, Transaction);
    event Signed(address indexed);
    event Completed(address indexed, Transaction);
    event Received(address indexed, uint256);

    constructor(address[] memory holders) {
        Holder memory h = _holder;
        for (uint8 i = 0; i < holders.length; i++) {
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

    function owner() public view returns (address) {
        return _owner;
    }

    function addHolder(address account) public override onlyHolder {
        require(account != address(0), "0 address can't be a holder");
        Holder memory h = _holder;
        h.holder = account;
        h.signed = false;
        _holders.push(h);

        _addHolder(account);
    }

    function replaceHolder(address currentAccount, address newAccount) public {
        require(_msgSender() == _owner, "not owner");
        require(newAccount != address(0), "0 address can't be a holder");
        Holder memory h = _holder;
        h.holder = newAccount;
        h.signed = false;
        _removeHolder(currentAccount);
        _holders[_getAccountNum(currentAccount)] = h;
        _addHolder(newAccount);
    }

    function initiateTransfer(uint256 amount, address sendTo)
        public
        onlyHolder
    {
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
    ) public onlyHolder {
        require(amount > 0, "transfer amount can't be zero");
        require(sendTo != address(0), "can't send to 0 address");

        _initiateTransfer(
            amount,
            coinAddressIfApplicable,
            sendTo,
            block.timestamp.add(10 minutes)
        );
    }

    function sign() public onlyHolder {
        require(!_hasSigned(_msgSender()), "already signed");
        _sign(_msgSender());
    }

    function completeTransfer(uint256 amount, address sendTo)
        public
        onlyHolder
    {
        require(_signatureNum > _holders.length.div(2), "over half must sign");
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

    function timeLeftSeconds() public view returns (uint256) {
        return _timeLeftSeconds();
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

    function _sign(address _account) private {
        _holders[_getAccountNum(_account)].signed = true;
        _signatureNum++;
        emit Signed(_account);
    }

    function _completeTransfer(
        uint256 _amount,
        IERC20 _coinAddress,
        address _sendTo
    ) private {
        _transaction.goodTillTime = 0;
        _signatureNum = 0;

        Holder[] storage _h = _holders;

        if (address(_coinAddress) == address(0)) {
            payable(_sendTo).transfer(_amount);
        } else {
            _coin = _coinAddress;
            _coin.transfer(_sendTo, _amount);
        }

        for (uint8 i = 0; i < _h.length; i++) {
            _h[i].signed = false;
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
        revert("account not found");
    }

    function _hasSigned(address _account) private view returns (bool) {
        return _holders[_getAccountNum(_account)].signed;
    }

    function _timeLeftSeconds() private view returns (uint256) {
        Transaction storage t = _transaction;
        uint256 time = t.goodTillTime;
        return time.sub(block.timestamp, "over time limit");
    }
}
