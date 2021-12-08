// SPDX - License - Identifier : UNLICENSED

pragma solidity >=0.4.22 <0.7.0;

import "./Token1.sol";
import "./Token2.sol";

contract TokenSwap {

uint256 private created;
uint256 private constant x = 10;
uint256 private constant y = 5;

mapping (address => bytes1) userRole;
mapping (address => address) tradePartner;
mapping (address => address payable) tokenAddresses;

enum Stage {FirstAccept, SecondAccept, Execute}
Stage public stage = Stage.FirstAccept;

function acceptTrade(address recipient, address payable tokenAddress) external {
	if (stage == Stage.FirstAccept) {
		userRole [msg.sender] = "A";
		stage = Stage.SecondAccept;
	} else if (stage == Stage.SecondAccept) {
		require (tradePartner[recipient] == msg.sender && tokenAddress != tokenAddresses[recipient]);
		userRole[msg.sender] = "B";
		created = now;
		stage = Stage.Execute;
	} else {
		revert ("Trade in progress");
	}
	tokenAddresses[msg.sender] = tokenAddress;
	tradePartner[msg.sender] = recipient;
}

function executeTrade() external {
	require (stage == Stage.Execute);
	if (userRole[msg.sender] == "A") {
		Token1 C1 = Token1(tokenAddresses[msg.sender]);
		Token2 C2 = Token2(tokenAddresses[tradePartner[msg.sender]]);
		C1.transfer(tradePartner[msg.sender], x);
		C2.transfer(msg.sender, y);
	} else if (userRole[msg.sender] == "B") {
		Token1 C1 = Token1(tokenAddresses[tradePartner[msg.sender]]);
		Token2 C2 = Token2(tokenAddresses[msg.sender]);
		C1.transfer(msg.sender, x);
		C2.transfer(tradePartner[msg.sender], y);
	} else {
		revert (" Trade in progress ");
	}	
	userRole[msg.sender] = "";
	userRole[tradePartner[msg.sender]] = "";
	tradePartner[tradePartner[msg.sender]] = address(0);
	tradePartner[msg.sender] = address(0);
	stage = Stage.FirstAccept;
}

function cancelTrade() external {
	require(stage == Stage.Execute && created + 1 days <= now );
	if (userRole[msg.sender] == "A") {
		Token1 C1 = Token1(tokenAddresses[msg.sender]);
		Token2 C2 = Token2(tokenAddresses[tradePartner[msg.sender]]);
		require(C2.getBalance() < y);
		C1.transfer(msg.sender, x);
	} else if (userRole[msg.sender] == "B") {
		Token1 C1 = Token1(tokenAddresses[tradePartner[msg.sender]]);
		Token2 C2 = Token2(tokenAddresses[msg.sender]);
		require(C1.getBalance() < x);
		C2.transfer(msg.sender, y);
	} else {
		revert ("Trade in progress");
	}
	userRole[msg.sender] = "";
	userRole[tradePartner[msg.sender]] = "";
	tradePartner[tradePartner[msg.sender]] = address(0);
	tradePartner[msg.sender] = address(0);
	stage = Stage.FirstAccept;
	}
	
	function getRole() external view returns (bytes1) {
		return userRole[msg.sender]
	}
}
