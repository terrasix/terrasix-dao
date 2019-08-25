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
    IUniswap public constant uniswap;

    /** Uniswap untree exchange contract */
    address public constant untreeExchange;

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
     *  repayments of externalities - as a donation
     */
    function()
        external
        payable
    {
        require(msg.data.length == 0,
            "No data can be passed.");
        // it's a donation, just transfer it onwards
        // to the reforestationDAO
        reforestationDAO.send(msg.value);
    }

    constructor(
        address _reforestationDAO,
        IUniswap _uniswap,
        address _untreeExchange
    )
        public
    {
        // TODO: write requirements, addresses not null.
        reforestationDAO = _reforestationDAO;
        uniswap = _uniswap;
        untreeExchange = _untreeExchange;
    }


    function plant()
        external
        payable
    {
        uint256 price;
        if (totalTreesPlanted < BOOTSTRAP_THRESHOLD) {
            price = BOOTSTRAP_PRICE;
        } else {
            price = uniswap.getPrice(untreeExchange);
        }

        require(msg.value > 100000,
            "Too small Wei values disallowed to avoid rounding errors.");

        // note: this is probably all sorts-of-wrong, but it's 3am, before the
        // hackathon deadline
        uint256 trees = msg.value * price / uint256(10**18);

        totalTreesPlanted = totalTreesPlanted.add(trees);

        if (totalTreesPlanted >= GOAL) {
            // give user all trees
            treeBalances[msg.sender] = treeBalances[msg.sender].add(trees);
            // TODO; quarterly account for tree balances
        } else {
            // issue unTrees and Trees to user
            uint256 untrees = trees * (1 - totalTreesPlanted / GOAL);
            issueUntrees(msg.sender, untrees);
            treeBalances[address(this)] = (treeBalances[msg.sender].add(trees)).sub(untrees);
        }
    }

    function 
}