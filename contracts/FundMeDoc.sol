// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Get funds from users
// Withdraw funds
// Set minimum funds value in USD
contract FundMeDoc {

    uint256 myValue = 1;

    // Allow users to send $
    // Have a minimum $ to sent
    // 1. How do we send ETH to this contract?
    function fund() public payable {
        myValue += 2;

        // 1e18 = 1 ETH = 1 * 10**9 gwei = 1 * 10**18 wei
        // What is the revert?
        //  - Undo any action that have been done, and send the remainding gas back
        //  -- even myValue will be reverted to previous state
        //  --- but gas spet for previous computation will be wasted
        // Transactions - Value Transfer
        // - Nonce: tx count for the account
        // - Gas Price: price per unit of gas (in wei)
        // - Gas Limit: 21000
        // - To: address that the tx is sent to
        // - Value: amount of wei to send
        // - Data: empty
        // - v,r,s: components of tx signature
        require(msg.value > 1e18, "didn't send enough ETH"); 
    }

    // function withdraw() public {}
}