// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;

import "../../GSN/Context.sol";
import "../../math/SafeMath.sol";

contract ERC2718 is Context {
    using SafeMath for uint256;

    struct Bundle {
        uint256 shares;
        uint256 votesLeft;
    }

    mapping(address => Bundle) private _balances;

    event Invested(address account, uint256 shares);
    event Voted(address account, uint256 votes);

    function invest(uint256 shares) public returns (bool) {
        _invest(_msgSender(), shares);
        return true;
    }

    function vote(uint256 votes) public returns (bool) {
        _vote(_msgSender(), votes);
        return true;
    }

    function _invest(address _owner, uint256 _shares) private {
        require(_owner != address(0), "cannot be 0 address");
        require(_shares > 0, "must buy more than 0 shares lol");
        Bundle storage b = _balances[_owner];

        b.shares = b.shares.add(_shares);
        b.votesLeft = b.votesLeft.add(_shares);

        emit Invested(_owner, _shares);
    }

    function _vote(address _owner, uint256 _votes) private {
        require(_owner != address(0), "cannot be 0 address");
        require(_votes > 0, "must use more than 0 votes lol");
        Bundle storage b = _balances[_owner];

        b.votesLeft = b.votesLeft.sub(_votes, "vote amount exceeds balance");

        emit Voted(_owner, _votes);
    }
}
