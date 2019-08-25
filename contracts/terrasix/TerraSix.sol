pragma solidity >=0.5.0 <0.6.0;

// Voor jou, en voor je toekomst, mijn liefste Siri
// een gelukkige tiende verjaardag!

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
     * Price in unTree/Wei, set to 0.1 ETH
     */
    uint256 public constant BOOTSTRAP_PRICE = uint256(100000000000000000);

    /** Bootstrap threshold, number of unTrees to be minted before referring
     * to Uniswap contract for unTree/ETH price; set to one million unTree.
     */
    uint256 public constant BOOTSTRAP_THRESHOLD = uint256(1000000);

    /** Flow minimally 98% onwards to reforestation DAO */
    uint256 public constant FLOW = uint256(98);

    /* Storage */

    /** Uniswap contract for price point Untree/ETH */
    IUniswap public uniswap;

    /** Uniswap untree exchange contract */
    address public untreeExchange;

    /** Address of reforestationDAO
     * DAO solely dedicated to funding projects for
     * reforestation, preservation and monitoring of forests
     * all over the world.
     */
    address payable public reforestationDAO;

    /** Tree balances, non-transferable */
    mapping(address => uint256) public treeBalances;

    /** Hero status, non-transferable reputation */
    mapping(address => uint256) public heroStatuses;

    /** Total trees planted */
    uint256 public totalTreesPlanted;

    /** Total hero status */
    uint256 public totalHeroStatus;

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
        reforestationDAO.transfer(msg.value);
    }

    constructor(
        address payable _reforestationDAO,
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
        // mint trees and untrees in equal amount
        uint256 trees = msg.value * price / uint256(10**18);

        totalTreesPlanted = totalTreesPlanted.add(trees);

        if (totalTreesPlanted >= GOAL) {
            // give user all trees
            treeBalances[msg.sender] = treeBalances[msg.sender].add(trees);
            // TODO; quarterly account for tree balances
        } else {
            // issue unTrees and Trees to user
            uint256 untrees = trees.mul( uint256(1).sub( totalTreesPlanted.div(GOAL) ) );
            issueUntrees(msg.sender, untrees);
            treeBalances[address(this)] = (treeBalances[msg.sender].add(trees)).sub(untrees);
        }

        // on planting all value is sent to reforestationDAO
        reforestationDAO.transfer(msg.value);
    }

    function accountForExternalities
    (
    )
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
       
        uint256 untrees = msg.value * price / uint256(10**18);

        require(untrees > 10**9,
            "Minimum amount of untree required.");

        burnUntree(msg.sender, untrees);

        uint256 deltaTrees = totalTreesPlanted.sub(totalSupply());

        // HERO status is a quadratic bonding curve in deltaTrees;
        // because paying off your externalities today, beats paying them off tomorrow.
        uint256 hero = untrees.div(deltaTrees.mul(deltaTrees));

        totalHeroStatus = totalHeroStatus.add(hero);
        heroStatuses[msg.sender] = heroStatuses[msg.sender].add(hero);

        // TODO; hold off (100 - FLOW)/100 for Tree payouts

        reforestationDAO.transfer(msg.value);
    }
}