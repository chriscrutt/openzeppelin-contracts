// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "../GSN/Context.sol";
import "../crowdsale/emission/MintedCrowdsale.sol";
import "../token/ERC1618/ERC1618MintableOmniscient.sol";
import "../token/ERC1618/ERC1618.sol";

/**
 * @title SampleCrowdsaleToken
 * @dev Very simple ERC1618 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
abstract contract SimpleCrowdsaleToken is ERC1618MintableOmniscient {
    constructor() ERC1618("Sample Crowdsale Token", "SCT", 18) {
        // solhint-disable-previous-line no-empty-blocks
    }
}

/**
 * @title SampleCrowdsale
 * @dev This is an example of a fully fledged crowdsale.
 * The way to add new features to a base crowdsale is by multiple inheritance.
 * In this example we are providing following extensions:
 * CappedCrowdsale - sets a max boundary for raised funds
 * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
 * MintedCrowdsale - assumes the token can be minted by the crowdsale, which does so
 * when receiving purchases.
 *
 * After adding multiple features it's good practice to run integration tests
 * to ensure that subcontracts works together as intended.
 */
contract SimpleCrowdsale is MintedCrowdsale {
    constructor(
        uint256 rate,
        address payable wallet,
        ERC1618MintableOmniscient token
    ) Crowdsale(rate, wallet, token) {}
}
