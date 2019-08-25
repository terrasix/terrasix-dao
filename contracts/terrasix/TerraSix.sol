pragma solidity >=0.5.0 <0.6.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

import "./IT6.sol";
import "../untree/unTree.sol";
import "../uniswap/IUniswap.sol";

contract TerraSix is IT6, Untree {

    /* Using */
    using SafeMath for uint256;

    /* Constants */

    /** Goal: plant 3 trillion new trees on Earth
     * expressed in Tree tokens with 18 decimal places of precision.
     */
    uint256 public constant GOAL = uint256(3000000000000000000000000000000);

    /** Bootstrap price 1 unTree until an initial supply is minted
     * Price in unTree/ETH, set to 0.1 ETH
     */
    uint256 public constant BOOTSTRAP_PRICE = uint256(100000000000000000);

    /** Bootstrap threshold, number of unTrees to be minted before referring
     * to Uniswap contract for unTree/ETH price; set to one million unTree.
     */
    uint256 public constant BOOTSTRAP_THRESHOLD = uint256(1000000);

    /* Storage */

    /** Uniswap contract for price point Untree/ETH */
    IUniswap public uniswap;

    /** Address of reforestationDAO
     * DAO solely dedicated to funding projects for
     * reforestation, preservation and monitoring of forests
     * all over the world.
     */
    address public reforestationDAO;

    /** Tree balances, non-transferable */
    mapping(address => uint256) public treeBalances;

    /** Hero status, non-transferable reputation */
    mapping(address => uint256) public heroStatuses;

    /** Total trees planted */
    uint256 public totalTreesPlanted;

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


    function plant()
        external
        payable
    {

    }
}