/** This example code is designed to quickly deploy an example contract using Remix.
 *  If you have never used Remix, try our example walkthrough: https://docs.chain.link/docs/example-walkthrough
 *  You will need testnet ETH and LINK.
 *     - Kovan ETH faucet: https://faucet.kovan.network/
 *     - Kovan LINK faucet: https://kovan.chain.link/
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "./AggregatorV3Interface.sol";

contract PriceConsumerV3 {
    AggregatorV3Interface private _priceFeed;

    constructor(AggregatorV3Interface priceFeed_) {
        _priceFeed = priceFeed_;
    }

    function getLatestPrice() public view returns (int256) {
        (, int256 answer, , , ) = _priceFeed.latestRoundData();
        return answer;
    }

    function decimals() public view returns (uint8) {
        return _priceFeed.decimals();
    }

    function description() public view returns (string memory) {
        return _priceFeed.description();
    }

    function version() public view returns (uint256) {
        return _priceFeed.version();
    }
}
