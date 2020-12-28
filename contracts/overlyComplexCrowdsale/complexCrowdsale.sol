// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "./AggregatorV3Interface.sol";
import "../math/SafeMath.sol";

// for Koven chain
contract EthToBtc {
    using SafeMath for int256;

    AggregatorV3Interface private _ethFeed;
    AggregatorV3Interface private _btcFeed;

    constructor() {
        _ethFeed = AggregatorV3Interface(
            0x9326BFA02ADD2366b30bacB125260Af641031331
        );
        _btcFeed = AggregatorV3Interface(
            0x6135b13325bfC4B00278B4abC5e20bbce2D6580e
        );
    }

    function getLatestEthPrice() public view returns (int256) {
        (, int256 answer, , , ) = _ethFeed.latestRoundData();
        return answer;
    }

    function getLatestBtcPrice() public view returns (int256) {
        (, int256 answer, , , ) = _btcFeed.latestRoundData();
        return answer;
    }

    function ethDecimals() public view returns (uint8) {
        return _ethFeed.decimals();
    }

    function btcDecimals() public view returns (uint8) {
        return _btcFeed.decimals();
    }

    function description() public pure returns (string memory) {
        return "ETH / BTC";
    }

    function getMainPrice() public view returns (int256){
        int256 ethPrice = getLatestEthPrice() * 10**8;
        int256 btcPrice = getLatestBtcPrice();
        int256 price = ethPrice.roundedDiv(btcPrice);
        return price;
    }
}
