// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DecentralizedExchange {
    address public admin;
    mapping(address => mapping(address => uint256)) public balances;

    event Deposit(address indexed depositor, address indexed token, uint256 amount);
    event Withdrawal(address indexed withdrawer, address indexed token, uint256 amount);
    event Trade(
        address indexed buyer,
        address indexed seller,
        address indexed token,
        uint256 amount,
        uint256 price
    );

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can call this function");
        _;
    }

    constructor() {
        admin = msg.sender;
    }
    function deposit(address _token, uint256 _amount) external {
        require(_amount > 0, "Deposit amount must be greater than 0");
        require(IERC20(_token).transferFrom(msg.sender, address(this), _amount), "Token transfer failed");

        balances[msg.sender][_token] += _amount;

        emit Deposit(msg.sender, _token, _amount);
    }

}

