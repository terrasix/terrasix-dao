pragma solidity >=0.5.0 <0.6.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

import "../terrasix/IT6.sol";

contract Untree is ERC20 {

    /* Storage */
    IT6 terrasix;

    modifier onlyTerraSix()
    {
        require(msg.sender == terrasix,
            "Only TerraSix can call.");
        _;
    }

    /* Special functions */
  
    constructor(
        IT6 _terrasix
    )
        public
    {
        require(_terrasix != IT6(0),
            "T6 cannot be null.");
        terrasix = _terrasix;
    }

    /* External functions */

    /** Issue unTrees as debt for future trees */
    function issueUntrees(address _account, uint256 _amount)
        external
        onlyTerrasix
    {
        _mint(_account, _amount);
    }
}