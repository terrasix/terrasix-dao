pragma solidity >=0.5.0 <0.6.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

import "../terrasix/IT6.sol";

contract Untree is ERC20 {

    /* Storage */

    /* Special functions */
  
    constructor(
    )
        public
    {
    }

    /* External functions */

    /** Issue unTrees as debt for future trees */
    function issueUntrees(address _account, uint256 _amount)
        internal
    {
        _mint(_account, _amount);
    }

    function burnUntree(address _account, uint256 _amount)
        internal
    {
        _burn(_account, _amount);
    }
}