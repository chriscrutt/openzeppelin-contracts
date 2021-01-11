// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "./RefundableCrowdsale.sol";
import "./PostDeliveryCrowdsale.sol";

/**
 * @title RefundablePostDeliveryCrowdsale
 * @dev Extension of RefundableCrowdsale contract that only delivers the tokens
 * once the crowdsale has closed and the goal met, preventing refunds to be issued
 * to token holders.
 */
abstract contract RefundablePostDeliveryCrowdsale is
    RefundableCrowdsale,
    PostDeliveryCrowdsale
{
    /**
     * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
     */
    function _forwardFunds()
        internal
        override(Crowdsale, RefundableCrowdsale)
    {
        RefundableCrowdsale._forwardFunds();
    }

    /**
     * @dev Overrides parent by storing due balances, and delivering tokens to the vault instead of the end user. This
     * ensures that the tokens will be available by the time they are withdrawn (which may not be the case if
     * `_deliverTokens` was called later).
     * @param beneficiary Token purchaser
     * @param tokenAmount Amount of tokens purchased
     */
    function _processPurchase(address beneficiary, uint256 tokenAmount)
        internal
        override(Crowdsale, PostDeliveryCrowdsale)
    {
        PostDeliveryCrowdsale._processPurchase(beneficiary, tokenAmount);
    }

    function withdrawTokens(address beneficiary) public override {
        require(finalized(), "RefundablePostDeliveryCrowdsale: not finalized");
        require(
            goalReached(),
            "RefundablePostDeliveryCrowdsale: goal not reached"
        );

        super.withdrawTokens(beneficiary);
    }
}
