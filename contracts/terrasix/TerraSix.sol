pragma solidity >=0.5.0 <0.6.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

import "../untree/unTree.sol";

contract TerraSix {

    /* Using */
    using SafeMath for uint256;

    /* Special functions */

    /** fallback function accepts ETH as collateral for
     *  repayments of externalities.
     */
    function()
        external
        payable
    {
        require(msg.data.length == 0,
            "No data can be passed.");
    }

    constructor(

    )
        public
    {

    }
}