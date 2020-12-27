// ERC201 example

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "./token/ERC20/IERC20.sol";
import "./token/ERC20/TokenTimelock.sol";
import "./token/ERC20/ERC20.sol";
import "./token/ERC20/ERC20Burnable.sol";
import "./token/ERC20/SafeERC20.sol";
import "./token/ERC20/ERC20Pausable.sol";
import "./token/ERC20/ERC20Snapshot.sol";
import "./token/ERC20/ERC20Capped.sol";
import "./token/ERC20/ERC20Mintable.sol";
import "./token/ERC777/IERC777Recipient.sol";
import "./token/ERC777/IERC777Sender.sol";
import "./token/ERC777/SafeERC777.sol";
import "./token/ERC777/ERC777.sol";
import "./token/ERC777/IERC777.sol";
import "./token/ERC721/IERC721Enumerable.sol";
import "./token/ERC721/IERC721Metadata.sol";
import "./token/ERC721/IERC721Receiver.sol";
import "./token/ERC721/ERC721Pausable.sol";
import "./token/ERC721/ERC721.sol";
import "./token/ERC721/IERC721.sol";
import "./token/ERC721/ERC721Holder.sol";
import "./token/ERC721/ERC721Burnable.sol";
import "./token/ERC201/ERC201TransferFrom.sol";
import "./token/ERC201/ERC201Mintable.sol";
import "./token/ERC201/ERC201Manage.sol";
import "./token/ERC201/ERC201MintableOmniscient.sol";
import "./token/ERC201/ERC201BurnableOmniscient.sol";
import "./token/ERC201/ERC201.sol";
import "./token/ERC201/IERC201.sol";
import "./token/ERC201/ERC201Burnable.sol";
import "./token/ERC1155/ERC1155.sol";
import "./token/ERC1155/ERC1155Receiver.sol";
import "./token/ERC1155/IERC1155Receiver.sol";
import "./token/ERC1155/IERC1155.sol";
import "./token/ERC1155/ERC1155Pausable.sol";
import "./token/ERC1155/IERC1155MetadataURI.sol";
import "./token/ERC1155/ERC1155Holder.sol";
import "./token/ERC1155/ERC1155Burnable.sol";
import "./proxy/Initializable.sol";
import "./proxy/ProxyAdmin.sol";
import "./proxy/UpgradeableProxy.sol";
import "./proxy/TransparentUpgradeableProxy.sol";
import "./proxy/IBeacon.sol";
import "./proxy/Proxy.sol";
import "./proxy/UpgradeableBeacon.sol";
import "./proxy/BeaconProxy.sol";
import "./access/Roles.sol";
import "./access/Ownable.sol";
import "./access/roles/WhitelistAdminRole.sol";
import "./access/roles/TrusteeRole.sol";
import "./access/roles/CapperRole.sol";
import "./access/roles/PartnerRole.sol";
import "./access/roles/WhitelistedRole.sol";
import "./access/roles/MinterRole.sol";
import "./access/roles/PauserRole.sol";
import "./access/TimelockController.sol";
import "./access/AccessControl.sol";
import "./GSN/GSNRecipientSignature.sol";
import "./GSN/IRelayHub.sol";
import "./GSN/GSNRecipientERC20Fee.sol";
import "./GSN/IRelayRecipient.sol";
import "./GSN/GSNRecipient.sol";
import "./GSN/Context.sol";
import "./cryptography/ECDSA.sol";
import "./cryptography/MerkleProof.sol";
import "./payment/PaymentSplitter.sol";
import "./payment/PullPayment.sol";
import "./payment/escrow/Escrow.sol";
import "./payment/escrow/RefundEscrow.sol";
import "./payment/escrow/ConditionalEscrow.sol";
import "./drafts/IERC20Permit.sol";
import "./drafts/ERC20Permit.sol";
import "./drafts/EIP712.sol";
import "./crowdsale/emission/MintedCrowdsale.sol";
import "./crowdsale/emission/AllowanceCrowdsale.sol";
import "./crowdsale/distribution/RefundableCrowdsale.sol";
import "./crowdsale/distribution/PostDeliveryCrowdsale.sol";
import "./crowdsale/distribution/FinalizableCrowdsale.sol";
import "./crowdsale/price/IncreasingPriceCrowdsale.sol";
import "./crowdsale/Crowdsale.sol";
import "./crowdsale/validation/IndividuallyCappedCrowdsale.sol";
import "./crowdsale/validation/PausableCrowdsale.sol";
import "./crowdsale/validation/TimedCrowdsale.sol";
import "./crowdsale/validation/WhitelistCrowdsale.sol";
import "./crowdsale/validation/CappedCrowdsale.sol";
import "./utils/ReentrancyGuard.sol";
import "./utils/Pausable.sol";
import "./utils/Counters.sol";
import "./utils/EnumerableMap.sol";
import "./utils/Arrays.sol";
import "./utils/Address.sol";
import "./utils/EnumerableSet.sol";
import "./utils/Create2.sol";
import "./utils/Strings.sol";
import "./utils/SafeCast.sol";
import "./introspection/IERC1820Registry.sol";
import "./introspection/IERC1820Implementer.sol";
import "./introspection/ERC165Checker.sol";
import "./introspection/ERC1820Implementer.sol";
import "./introspection/ERC165.sol";
import "./introspection/IERC165.sol";
import "./math/SafeMath.sol";
import "./math/SignedSafeMath.sol";
import "./math/Math.sol";
import "./ownership/Secondary.sol";
import "./examples/Simple201.sol";
import "./testFile.sol";
import "./presets/ERC1155PresetMinterPauser.sol";
import "./presets/ERC721PresetMinterPauserAutoId.sol";
import "./presets/ERC777PresetFixedSupply.sol";
import "./presets/ERC20PresetMinterPauser.sol";
import "./presets/ERC20PresetFixedSupply.sol";
