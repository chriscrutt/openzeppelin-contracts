// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "../../GSN/Context.sol";
import "../../token/ERC1618/IERC1618.sol";
import "../../math/SafeMath.sol";

/**
 * @title A truly Decentralized Token
 *
 * @author Ivory B. Mendel from ERC20 token in openzeppelin-contracts
 *
 * @notice A no BS token based off of ERC20 that DEFAULTS owner to
 * having no control over the tokens or others' accounts (unless
 * otherwise specified)
 *
 * @dev there are mint, burn, & other functions only accessible through
 * specification of other contracts. Example would be creating a ERC1618
 * mintable token that can access the internal function _mint not
 * accessible in the default contract
 */
contract ERC1618 is Context, IERC1618 {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for `name_`, `symbol_`, and `decimals_`. All
     * three of these values are immutable: they can only be set once
     * during construction.
     *
     * @param name_ to be the name of the token
     * @param symbol_ to be the symbol of the token
     * @param decimals_ to be the number of decimals for the token
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    /**
     * @return Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @return Returns the symbol of the token, usually a shorter
     * version of the name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user
     * representation. For example, if `decimals` equals `2`, a balance
     * of `505` tokens should be displayed to a user as
     * `5.05` (`505 / 10 ** 2`)
     *
     * @return Returns the number of decimals of the token
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC1618-totalSupply}.
     *
     * @return Returns the total supply of the token
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC1618-balanceOf}.
     *
     * @return Returns the balance of the token for a specific address
     */
    function balanceOf(address account)
        public
        view
        override
        returns (uint256)
    {
        return _balances[account];
    }

    /**
     * @dev See {IERC1618-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     *
     * @param recipient address to receive token
     * @param amount number of tokens to be transferred
     *
     * @return if transfer was successful
     */
    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @notice Moves tokens `amount` from `sender` to `recipient`.
     *
     * @dev This is internal function is equivalent to {transfer}, and
     * can be used to - e.g. implement automatic token fees
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     *
     * @param sender address to transfer token
     * @param recipient address to receive token
     * @param amount number of tokens to be transferred
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(
            recipient != address(0),
            "ERC1618: transfer to the zero address"
        );

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(
            amount,
            "ERC1618: transfer amount exceeds balance"
        );
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @notice Creates `amount` tokens and assigns them to `account`,
     * increasing the total supply.
     *
     * @dev Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:

     * - `account` cannot be the zero address.
     *
     * @param account address to receive tokens
     * @param amount number of tokens to be minted
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC1618: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @notice Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * @dev Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     *
     * @param account address where tokens are being burned
     * @param amount number of tokens to be burned
     */
    function _burn(address account, uint256 amount) internal {
        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(
            amount,
            "ERC1618: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev See {IERC1618-transferFrom}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     *
     * @param sender address to transfer token
     * @param recipient address to receive token
     * @param amount number of tokens to be transferred
     */
    function _transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        _transfer(sender, recipient, amount);
        return true;
    }

    /**
     * @notice Hook that is called before any transfer of tokens. This
     * includes minting and burning.
     *
     * @dev Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s
     * tokens will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to
     * xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     *
     * @param from address to transfer token
     * @param to address to receive token
     * @param amount number of tokens to be transferred
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal {}
}
