// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../proxy/Initializable.sol";

// Sample contracts showing upgradeability with multiple inheritance.
// Child contract inherits from Father and Mother contracts, and Father extends from Gramps.
// 
//         Human
//       /       \
//      |       Gramps
//      |         |
//    Mother    Father
//      |         |
//      -- Child --

/**
 * Sample base intializable contract that is a human
 */
contract SampleHuman is Initializable {
  bool public isHuman;

  function initialize() public initializer {
    isHuman = true;
  }
}

/**
 * Sample base intializable contract that defines a field mother
 */
contract SampleMother is Initializable, SampleHuman {
  uint public mother;

  function initialize(uint value) public initializer virtual {
    SampleHuman.initialize();
    mother = value;
  }
}

/**
 * Sample base intializable contract that defines a field gramps
 */
contract SampleGramps is Initializable, SampleHuman {
  string public gramps;

  function initialize(string memory value) public initializer virtual {
    SampleHuman.initialize();
    gramps = value;
  }
}

/**
 * Sample base intializable contract that defines a field father and extends from gramps
 */
contract SampleFather is Initializable, SampleGramps {
  uint public father;

  function initialize(string memory _gramps, uint _father) public initializer {
    SampleGramps.initialize(_gramps);
    father = _father;
  }
}

/**
 * Child extends from mother, father (gramps)
 */
contract SampleChild is Initializable, SampleMother, SampleFather {
  uint public child;

  function initialize(uint _mother, string memory _gramps, uint _father, uint _child) public initializer {
    SampleMother.initialize(_mother);
    SampleFather.initialize(_gramps, _father);
    child = _child;
  }
}
