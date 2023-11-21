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

function withdraw(address _token, uint256 _amount) external {
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(balances[msg.sender][_token] >= _amount, "Insufficient balance");

        balances[msg.sender][_token] -= _amount;
        require(IERC20(_token).transfer(msg.sender, _amount), "Token transfer failed");

        emit Withdrawal(msg.sender, _token, _amount);
    }

function trade(
        address _buyer,
        address _seller,
        address _token,
        uint256 _amount,
        uint256 _price
    ) external onlyAdmin {
        require(balances[_seller][_token] >= _amount, "Insufficient seller balance");
        require(balances[_buyer][_token] >= _amount, "Insufficient buyer balance");

        uint256 totalTradeValue = _amount * _price;

        balances[_seller][_token] -= _amount;
        balances[_seller][address(0)] += totalTradeValue;

        balances[_buyer][_token] += _amount;
        balances[_buyer][address(0)] -= totalTradeValue;

        emit Trade(_buyer, _seller, _token, _amount, _price);
    }
function getBalance(address _user, address _token) external view returns (uint256) {
        return balances[_user][_token];
    }

}

