// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../access/roles/HolderRole.sol";
import "../GSN/Context.sol";
import "../token/ERC20/IERC20.sol";

contract MultiSig is Context, HolderRole {
    struct Sig {
        uint256 amount;
        uint256 timeStamp;
        address coinAddress;
        address sendTo;
    }

    IERC20 private _coin;

    address[] private _holderArray;

    mapping(address => Sig) private _holderMap;

    event Received(address, uint256);

    constructor(address[] memory holders) {
        for (uint256 i = 0; i < holders.length; i++) {
            _holderMap[holders[i]].amount = 0;
            _holderMap[holders[i]].timeStamp = 0;
            _holderMap[holders[i]]
                .coinAddress = 0x8b1A1aF63bb9b3730f62c56bDa272BCC69dF4CC7;
            _holderMap[holders[i]].sendTo = address(0);
            _addHolder(holders[i]);
        }
        _holderArray = holders;
    }

    receive() external payable {
        emit Received(_msgSender(), msg.value);
    }

    function initiateTransfer(
        uint256 baseAmount,
        address coinAddress,
        address sendTo
    ) public onlyHolder {
        _initiateTransfer(baseAmount, coinAddress, block.timestamp, sendTo);
    }

    function completeTransfer(
        uint256 baseAmount,
        address coinAddress,
        address sendTo
    ) public onlyHolder returns (bool) {
        uint256 timeStamp = block.timestamp;

        _initiateTransfer(baseAmount, coinAddress, timeStamp, sendTo);

        uint256 j = 0;
        for (uint256 i = 0; i < _holderArray.length; i++) {
            if (
                _seeTime(timeStamp, _holderMap[_holderArray[i]].timeStamp) <
                600
            ) {
                if (baseAmount == _holderMap[_holderArray[i]].amount) {
                    if (
                        coinAddress == _holderMap[_holderArray[i]].coinAddress
                    ) {
                        if (sendTo == _holderMap[_holderArray[i]].sendTo) {
                            j++;
                            if (j > _holderArray.length) {
                                _doIt(baseAmount, coinAddress, sendTo);
                                return true;
                            }
                        }
                    }
                }
            }
        }
        return false;
    }

    function _initiateTransfer(
        uint256 _baseAmount,
        address _coinAddress,
        uint256 _timeStamp,
        address _sendTo
    ) private {
        require(_baseAmount > 0);
        require(_isCoin(_coinAddress));
        require(_sendTo != address(0));
        _holderMap[_msgSender()].amount = _baseAmount;
        _holderMap[_msgSender()].coinAddress = _coinAddress;
        _holderMap[_msgSender()].timeStamp = _timeStamp;
        _holderMap[_msgSender()].sendTo = _sendTo;
    }

    function _doIt(
        uint256 _baseAmount,
        address _coinAddress,
        address _sendTo
    ) private {
        if (_coinAddress == address(0)) {
            payable(_sendTo).transfer(_baseAmount);
        } else {
            _coin = IERC20(_coinAddress);
            _coin.transfer(_sendTo, _baseAmount);
        }
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

    function _seeTime(uint256 _now, uint256 _then)
        private
        pure
        returns (uint256)
    {
        return _now - _then;
    }
}
