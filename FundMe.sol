// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

// Get funds from users
// Withdraw funds
// Set minimum funds value in USD
contract FundMe {

    using PriceConverter for uint256;

    // 5 USD => 5e18 because of presigion
    uint256 public constant MINIMUM_USD = 5e18; 

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    // https://docs.chain.link/data-feeds/price-feeds/addresses?page=1&testnetPage=1&networkType=testnet&search=&testnetSearch=
    /**
     * Network: Ethereum Testnet
     * Aggregator: ETH/USD
     * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
     */
    address internal priceFeedAddress;

    constructor() {
        priceFeedAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        i_owner = msg.sender;
    }

    // Allow users to send $
    // Have a minimum $ to sent
    function fund() public payable {
        require(msg.value.getConversionRate(priceFeedAddress) >= MINIMUM_USD, "didn't send enough ETH"); 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    /* https://solidity-by-example.org/
    * Sending ETH From a Contract.  
    * An exploration of three methods for sending Ether from a contract in Solidity: transfer, send, and call.
    *  - transfer (2300 gas, throws error)
    *  - send (2300 gas, returns bool)
    *  - call (forward all gas or set gas, returns bool)
    */
    function withdraw() public onlyOwner {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        // use here anz of: transfer, send, and call
                
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    // msg.sender = address
    // payable(msg.sender) = payable address

    // 1. transfer (2300 gas, throws error)
    function transfer() private {
        payable(msg.sender).transfer(address(this).balance);
        // automaticly revert in case of failier
    }
    // 2. send (2300 gas, returns bool)
    function send() private returns(bool) {
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");
        return sendSuccess;
    }
    // 3. call (forward all gas or set gas, returns bool)
    // https://solidity-by-example.org/call/
    function call() private returns(bool) {
        // we just sending the funds, no need to specify the function name
        bytes memory functionToCall = "";
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}(functionToCall);
        require(callSuccess, "Call failed");
        return callSuccess;
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not the owner");
        if(msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

}
