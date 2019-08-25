pragma solidity >=0.5.0 <0.6.0;

interface IUniswap {
    // Uniswap interface functions for getting price Untree/ETH
    // TODO: add actual function signature
    function getPrice(address _exchange) external view returns (uint256);
}