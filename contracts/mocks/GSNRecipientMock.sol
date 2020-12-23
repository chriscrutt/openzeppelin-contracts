// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "./ContextMock.sol";
import "../GSN/GSNRecipient.sol";

// By inheriting from GSNRecipient, Context's internal functions are overridden automatically
contract GSNRecipientMock is ContextMock, GSNRecipient {
    function withdrawDeposits(uint amount, address payable payee) public {
        _withdrawDeposits(amount, payee);
    }

    function acceptRelayedCall(address, address, bytes calldata, uint, uint, uint, uint, bytes calldata, uint)
        external
        view
        override
        returns (uint, bytes memory)
    {
        return (0, "");
    }

    function _preRelayedCall(bytes memory) internal override returns (bytes32) { }

    function _postRelayedCall(bytes memory, bool, uint, bytes32) internal override { }

    function upgradeRelayHub(address newRelayHub) public {
        return _upgradeRelayHub(newRelayHub);
    }

    function _msgSender() internal override(Context, GSNRecipient) view virtual returns (address payable) {
        return GSNRecipient._msgSender();
    }

    function _msgData() internal override(Context, GSNRecipient) view virtual returns (bytes memory) {
        return GSNRecipient._msgData();
    }
}
