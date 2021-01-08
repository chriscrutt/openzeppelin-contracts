pragma solidity >=0.6.0 <0.9.0;

import "../access/roles/HolderRole.sol";
import "../GSN/Context.sol";
import "../token/ERC20/IERC20.sol";
import "../math/SafeMath.sol";

contract MultiSig is Context, HolderRole {
    using SafeMath for uint256;
}