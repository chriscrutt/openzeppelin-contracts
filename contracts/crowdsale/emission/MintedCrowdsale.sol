// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../Crowdsale.sol";
import "../../token/ERC1618/ERC1618MintableOmniscient.sol";

/**
 * @title MintedCrowdsale
 * @notice tokens are minted upon ether reception instead of transferred
 * @dev Extension of Crowdsale contract whose tokens are minted in each
 * purchase. Token ownership should be transferred to MintedCrowdsale
 * for minting.
 */
abstract contract MintedCrowdsale is Crowdsale {
    /**
     * @dev Overrides delivery by minting tokens upon purchase.
     * @param beneficiary Token purchaser
     * @param tokenAmount Number of tokens to be minted
     */
    function _deliverTokens(address beneficiary, uint256 tokenAmount)
        internal
        virtual
        override
    {
        // Potentially dangerous assumption about the type of the token.
        require(
            ERC1618MintableOmniscient(address(token())).mint(
                beneficiary,
                tokenAmount
            ),
            "MintedCrowdsale: minting failed"
        );
    }
}
