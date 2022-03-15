// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Market {

    enum ROUTE {
        NONE,
        FROM_TO,
        TO_FROM
    }
    struct Record {
        address initiator;
        string fromToken;
        string toToken;
        Route route;
        uint256 fromAmount;
        uint256 toAmount;
        uint256 timestamp;
        uint256 fromTokenBalanceBefore;
        uint256 fromTokenBalanceAfter;
        uint256 toTokenBalanceBefore;
        uint256 toTokenBalanceAfter;
        uint8 decimals;
        uint32 price;
    }

    AggregatorV3Interface internal priceFeed;
    string public fromToken;
    string public toToken;
    mapping(string => address) tokenAddresses;
    mapping(uint => Record) records;

    constructor(string memory _from, address _fromAddr, string memory _to, address _toAddr, address _aggregatorAddress) public {
        fromToken = _from;
        toToken = _to;
        tokenAddresses[_from] = _fromAddr;
        tokenAddresses[_to] = _toAddr;
        priceFeed = AggregatorV3Interface(_aggregatorAddress);
    }

    function getQuote(string memory from, string memory to, uint fromAmount) public view returns (int price, uint8 priceDecimals, uint result) {
        ROUTE _route;

        if (hashString(from)==hashString(fromToken) && hashString(to)==hashString(toToken)) {
            _route = ROUTE.FROM_TO;    
        }
        else if (hashString(from)==hashString(toToken) && hashString(to)==hashString(fromToken)) {
            _route = ROUTE.TO_FROM;
        }
        
        if (_route == ROUTE.NONE){
            revert("Invalid route");
        }
        
        priceDecimals = priceFeed.decimals();
        (
            /*uint80 roundID*/,
            price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();

        result = calculateResult(_route, uint(price), priceDecimals, fromAmount);

    }

    function calculateResult(ROUTE _route, uint price, uint8 priceDecimals, uint amount) internal pure returns (uint result) {
        if (_route == ROUTE.NONE){
            revert("Invalid route");
        }

        if (_route == ROUTE.FROM_TO) {
            result = (price * amount ) / 10 ** priceDecimals;
        }

        else if (_route == ROUTE.TO_FROM) {
            result = (10 ** priceDecimals * amount) / price;
        }
    }

    function hashString(string memory _str) internal pure returns (bytes32) {
        bytes memory _bytes = bytes(_str);
        return keccak256(_bytes);
    }

    
}