// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// use Oracle, doc is here:
// https://docs.chain.link/vrf
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    // https://docs.chain.link/data-feeds/price-feeds/addresses?page=1&testnetPage=1&networkType=testnet&search=&testnetSearch=
    /**
     * Network: Ethereum Testnet
     * Aggregator: ETH/USD
     * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
     */

    /**
     * Returns the latest price of ETH/USD.
     * price * 1e8
     */
    function getLatestPrice(address priceFeedAddress) internal view returns (int256) {
        (
            /*uint80 roundID*/,
            int256 price,
            /*uint256 startedAt*/,
            /*uint256 timeStamp*/,
            /*uint80 answeredInRound*/
        ) = AggregatorV3Interface(priceFeedAddress).latestRoundData();
        return price;
    }

    /**
     * Returns the latest price of ETH/USD. 
     * price * 1e18
     */
    function getPrice(address priceFeedAddress) internal view returns(uint256) {
        uint256 latestPrice = uint256(getLatestPrice(priceFeedAddress));
        // Price of ETH in terms of USD
        // 2000.00000000 ( price * 1e8 )
        return latestPrice * 1e10;
    }

    function getConversionRate(uint256 ethAmount, address priceFeedAddress) internal view returns(uint256) {
        // 1 ETH ?
        // 2000 * 1e18
        uint256 ethPrice = getPrice(priceFeedAddress);
        // (2000 * 1e18      *     1 * 1e18) / 1e18
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd; 
    }

    function getVersion(address priceFeedAddress) internal view returns(uint256) {
        // Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI: 
        return AggregatorV3Interface(priceFeedAddress).version();
    }

}