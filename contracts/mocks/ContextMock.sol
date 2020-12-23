// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../GSN/Context.sol";

contract ContextMock is Context {
    event Sender(address sender);

    function msgSender() public {
        emit Sender(_msgSender());
    }

    event Data(bytes data, uint integerValue, string stringValue);

    function msgData(uint integerValue, string memory stringValue) public {
        emit Data(_msgData(), integerValue, stringValue);
    }
}

contract ContextMockCaller {
    function callSender(ContextMock context) public {
        context.msgSender();
    }

    function callData(ContextMock context, uint integerValue, string memory stringValue) public {
        context.msgData(integerValue, stringValue);
    }
}
