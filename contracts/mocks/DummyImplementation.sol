// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

abstract contract Impl {
  function version() public pure virtual returns (string memory); 
}

contract DummyImplementation {
  uint public value;
  string public text;
  uint[] public values;

  function initializeNonPayable() public {
    value = 10;
  }

  function initializePayable() public payable {
    value = 100;
  }

  function initializeNonPayableWithValue(uint _value) public {
    value = _value;
  }

  function initializePayableWithValue(uint _value) public payable {
    value = _value;
  }

  function initialize(uint _value, string memory _text, uint[] memory _values) public {
    value = _value;
    text = _text;
    values = _values;
  }

  function get() public pure returns (bool) {
    return true;
  }

  function version() public pure virtual returns (string memory) {
    return "V1";
  }

  function reverts() public pure {
    require(false, "DummyImplementation reverted");
  }
}

contract DummyImplementationV2 is DummyImplementation {
  function migrate(uint newVal) public payable {
    value = newVal;
  }

  function version() public pure override returns (string memory) {
    return "V2";
  }
}
