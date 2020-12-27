// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.9.0;

import "../../GSN/Context.sol";
import "../../math/SafeMath.sol";

// struct Voter {
//     uint256 shares;
//     uint256 votes;
//     string campaignsIn;
//     uint256 numCampaigns;
// }

// contract ERC2718 is Context {
//     using SafeMath for uint256;

//     mapping(address => Voter) private _balances;
//     mapping(string => Campaign) private _campaigns;

//     uint256 private _totalSupply;

//     string private _name;
//     string private _symbol;

//     event Invested(address account, uint256 shares);
//     event Voted(address account, uint256 votes);

//     event Transfer(address from, address to, uint256 value);

//     struct Campaign {
//         address creator;
//         uint256 votingGoal;
//         uint256 numVoters;
//         uint256 votes;
//         mapping(address => Voter) voters;
//     }

//     constructor(string memory name_, string memory symbol_) {
//         _name = name_;
//         _symbol = symbol_;
//     }

//     function name() public view returns (string memory) {
//         return _name;
//     }

//     function symbol() public view returns (string memory) {
//         return _symbol;
//     }

//     function totalSupply() public view returns (uint256) {
//         return _totalSupply;
//     }

//     function balanceOf(address account) public view returns (uint256) {
//         Voter storage b = _balances[account];
//         return b.shares;
//     }

//     function votes(address account) public view returns (uint256) {
//         Voter storage b = _balances[account];
//         return b.votes;
//     }

//     function invest(uint256 shares) public returns (bool) {
//         _invest(_msgSender(), shares);
//         return true;
//     }

//     function vote(uint256 votes_) public returns (bool) {
//         _vote(_msgSender(), votes_);
//         return true;
//     }

//     function _invest(address _owner, uint256 _shares) private {
//         require(_owner != address(0), "cannot be 0 address");
//         require(_shares > 0, "must buy more than 0 shares lol");
//         Voter storage b = _balances[_owner];

//         _totalSupply = _totalSupply.add(_shares);
//         b.shares = b.shares.add(_shares);
//         b.votes = b.votes.add(_shares);

//         emit Invested(_owner, _shares);
//     }

//     function _vote(address _owner, uint256 _votes) private {
//         require(_owner != address(0), "cannot be 0 address");
//         require(_votes > 0, "must use more than 0 votes lol");
//         Voter storage b = _balances[_owner];

//         b.votes = b.votes.sub(_votes, "vote amount exceeds balance");

//         emit Voted(_owner, _votes);
//     }

//     function transferShares(address _to, uint256 _amount)
//         public
//         returns (bool)
//     {
//         _transferShares(_msgSender(), _to, _amount, false);
//         return true;
//     }

//     function transferSharesWithVotes(address _to, uint256 _amount)
//         public
//         returns (bool)
//     {
//         _transferShares(_msgSender(), _to, _amount, true);
//         return true;
//     }

//     function transferVotes(address _to, uint256 _amount)
//         public
//         returns (bool)
//     {
//         _transferVotes(_msgSender(), _to, _amount);
//         return true;
//     }

//     function _transferShares(
//         address _sender,
//         address _recipient,
//         uint256 _amount,
//         bool _withVotes
//     ) internal {
//         require(
//             _recipient != address(0),
//             "ERC1618: transfer to the zero address"
//         );
//         require(_amount > 0, "probably want to give more than 0 shares lol");

//         Voter storage _s = _balances[_sender];
//         _s.shares = _s.shares.sub(_amount, "transfer amount exceeds balance");

//         Voter storage _r = _balances[_recipient];

//         if (_withVotes) {
//             if (_s.votes < _amount) {
//                 uint256 _tempVotes = _s.votes;
//                 _s.votes = 0;
//                 _r.votes = _tempVotes;
//             } else {
//                 _s.votes = _s.votes.sub(
//                     _amount,
//                     "transfer amount exceeds balance"
//                 );
//                 _r.votes = _r.votes.add(_amount);
//             }
//         }

//         _r.shares = _r.shares.add(_amount);
//         emit Transfer(_sender, _recipient, _amount);
//     }

//     function _transferVotes(
//         address _sender,
//         address _recipient,
//         uint256 _amount
//     ) internal {
//         require(
//             _recipient != address(0),
//             "ERC1618: transfer to the zero address"
//         );
//         require(_amount > 0, "probably want to give more than 0 votes lol");

//         Voter storage _s = _balances[_sender];
//         _s.votes = _s.votes.sub(_amount, "transfer amount exceeds balance");

//         Voter storage _r = _balances[_recipient];
//         _r.votes = _r.votes.add(_amount);

//         _r.shares = _r.shares.add(_amount);
//     }

//     function _newCampaign(
//         address _creator,
//         uint256 _goal,
//         string memory _campaignName
//     ) private {
//         require(_goal > 0, "goal must be larger than 0");
//         require(
//             !_campaigns[_campaignName],
//             "Campaign with name already exists"
//         );

//         Campaign storage c = _campaigns[_campaignName];
//         c.creator = _creator;
//         c.votingGoal = _goal;
//     }

//     function newCampaign(uint256 goal, string memory campaignName)
//         public
//         returns (bool)
//     {
//         _newCampaign(_msgSender(), goal, campaignName);
//         return true;
//     }

//     function _vote(address _contributor, string memory _campaignName, uint _amount) private {
//         Voter storage v = _balances[_contributor];
//         v.votes = v.votes.sub(_amount, "vote amount exceeds balance");
        
//         Campaign storage c = _campaigns[_campaignName];
        

        
//     }
// }
