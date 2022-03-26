// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
interface IERC20{
    function transferFrom(address _from,address _to,uint256 _amount) external returns(bool);
    function transfer(address _to,uint256 _amount) external returns(bool);
}


contract Market {
    /**
    * @dev Market contract
    * Market contract acts as a proxy for the underlying ERC20 token contract.
    * It allows the user to buy and sell tokens on the exchange.
    */

    enum ROUTE {
        NONE,
        FROM_TO,
        TO_FROM
    }
    struct Record {
        address initiator;
        string fromToken;
        string toToken;
        ROUTE route;
        uint256 fromAmount;
        uint256 toAmount;
        uint256 timestamp;
        uint8 decimals;
        uint32 price;
    }

    event Notify(Record record);

    AggregatorV3Interface internal priceFeed;
    string public fromToken;
    string public toToken;
    mapping(string => IERC20) tokenContracts;
    mapping(uint => Record) records;
    uint256 internal lastRecordId = 0;


    modifier noNoneRoute(ROUTE _route) {
        require(_route != ROUTE.NONE, "Invalid Route");
        _;
    }


    /**
    * @dev The initiator allows cutomization at deployment time.
    * Args:
    * _fromAddr: fromToken's Address
    * _toAddr: toToken's Address
    * _aggregatorAddress: priceFeed aggregator's address
    *
    * *symbols for tokens are automatically fetched and updated
    */
    constructor(address _fromAddr, address _toAddr, address _aggregatorAddress) public {
        tokenContracts[_from] = IERC20(_fromAddr);
        fromToken = tokenContracts[_from].symbol();
        tokenContracts[_to] = IERC20(_toAddr);
        toToken = tokenContracts[_to].symbol();
        priceFeed = AggregatorV3Interface(_aggregatorAddress);
    }


    /**
    * @dev
    *   Public function to get quote for token-pair exchange
    *   without actually performing an exchange. It obtains price used
    *   for the estimation from the chainfeed
    * Args:
    *  _from: fromToken symbol
    *  _to: toToken symbol
    *  _fromAmount: amount of fromToken to be calculated for
    * Returns:
    *  _price: price used for this calculation
    *  _priceDecimals: decimals for price
    *  _result: result of calculation. the quote
    *  _route: direction of the operation
    *
    */
    function getQuote(string memory _from, string memory _to, uint _fromAmount)
        public view returns (int _price, uint8 _priceDecimals, uint _result, Route _route)
    {

        ROUTE _route;
        if (_hashString(_from)==_hashString(fromToken) && _hashString(_to)==_hashString(toToken)) {
            _route = ROUTE.FROM_TO;
        }
        else if (_hashString(_from)==_hashString(toToken) && _hashString(_to)==_hashString(fromToken)) {
            _route = ROUTE.TO_FROM;
        }

        if (_route == ROUTE.NONE){
            revert("Invalid route, check pairs");
        }

        _priceDecimals = priceFeed.decimals();
        (,_price,,,) = priceFeed.latestRoundData();
        result = _calculateResult(_route, uint(price), priceDecimals, fromAmount);

    }


    /**
    * @dev
    *  Internal helper function to calculate results based on conversion route and price data
    *  - Args
    *    _route: direction of the operation
    *    _price: price used for this calculation
    *    _priceDecimals: decimals for price
    *    _amount: amount of token to calculate for
    *  - Returns
    *    _result: result of calculation. the quote
    */
    function _calculateResult(ROUTE _route, uint price, uint8 priceDecimals, uint amount)
        internal pure noNoneRoute(_route) returns (uint _result)
    {
        if (_route == ROUTE.FROM_TO) {
            result = (price * amount ) / 10 ** priceDecimals;
        }

        else if (_route == ROUTE.TO_FROM) {
            result = (10 ** priceDecimals * amount) / price;
        }
    }

    /**
    *@dev
    * Internal helper function to convert a string to hashed bytes32
    * Args:
    *  - _str: string to hash
    * Returns:
    *  - _hashed: keccak256 hashed value of _str
    */
    function _hashString(string memory _str) internal pure returns (bytes32 _hashed) {
        _hashed = keccak256(bytes(_str));
    }

    
    function swap(string memory _from, string memory _to, uint256 _amount) public payable {
        ++lastRecordId;

        (int _price,  uint8 _priceDecimals, uint _result, Route _route ) = getQuote(_from, _to, _amount);
        require(_result > 0, "Invalid exchange");
        if (_route == ROUTE.FROM_TO){
            IERC20 from = tokenContracts[fromToken];
            IERC20 to = tokenContracts[toToken];
        }
        else if (_route == ROUTE.TO_FROM){
            IERC20 from = tokenContracts[toToken];
            IERC20 to = tokenContracts[fromToken];
        }

        // check that contract have enough balance for transaction
        require(to.balanceOf(address(this)) >= _result, "Insufficient liquidity to fulfil swap")
        // move fromToken from initiator to contract via allowance
        require(from.transferFrom(_record.initiator, address(this), _fromAmount), "Failed to transfer from initiator");

        Record storage _record = records[lastRecordId];

        _record.initiator = msg.sender;
        _record.fromToken = _from;
        _record.toToken = _to;
        _record.route = _route;
        _record.fromAmount = _amount;
        _record.toAmount = _result;
        _record.timestamp = block.timestamp;
        _record.decimals = _priceDecimals;
        _record.price = _price;

        // move toToken from contract to initiator
        require(to.transfer(_record.initiator, _toAmount), "Failed to transfer to initiator");
    }
    
}