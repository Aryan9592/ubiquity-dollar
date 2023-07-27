// SPDX-License-Identifier: MIT
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol. SEE BELOW FOR SOURCE. !!
pragma solidity 0.8.19;

/**
 * @notice Curve Factory interface
 * @notice Permissionless pool deployer and registry
 */
interface ICurveFactory {
    /// @notice Emitted when a new base pool is added
    event BasePoolAdded(address base_pool, address implementat);

    /// @notice Emitted when a new MetaPool is deployed
    event MetaPoolDeployed(
        address coin,
        address base_pool,
        uint256 A,
        uint256 fee,
        address deployer
    );

    /**
     * @notice Finds an available pool for exchanging two coins
     * @param _from Address of coin to be sent
     * @param _to Address of coin to be received
     * @return Pool address
     */
    function find_pool_for_coins(
        address _from,
        address _to
    ) external view returns (address);

    /**
     * @notice Finds an available pool for exchanging two coins
     * @param _from Address of coin to be sent
     * @param _to Address of coin to be received
     * @param i Index value. When multiple pools are available this value is used to return the n'th address.
     * @return Pool address
     */
    function find_pool_for_coins(
        address _from,
        address _to,
        uint256 i
    ) external view returns (address);

    /**
     * @notice Get the number of coins in a pool
     * @param _pool Pool address
     * @return Number of coins
     */
    function get_n_coins(
        address _pool
    ) external view returns (uint256, uint256);

    /**
     * @notice Get the coins within a pool
     * @param _pool Pool address
     * @return List of coin addresses
     */
    function get_coins(address _pool) external view returns (address[2] memory);

    /**
     * @notice Get the underlying coins within a pool
     * @dev Reverts if a pool does not exist or is not a metapool
     * @param _pool Pool address
     * @return List of coin addresses
     */
    function get_underlying_coins(
        address _pool
    ) external view returns (address[8] memory);

    /**
     * @notice Get decimal places for each coin within a pool
     * @param _pool Pool address
     * @return uint256 list of decimals
     */
    function get_decimals(
        address _pool
    ) external view returns (uint256[2] memory);

    /**
     * @notice Get decimal places for each underlying coin within a pool
     * @param _pool Pool address
     * @return uint256 list of decimals
     */
    function get_underlying_decimals(
        address _pool
    ) external view returns (uint256[8] memory);

    /**
     * @notice Get rates for coins within a pool
     * @param _pool Pool address
     * @return Rates for each coin, precision normalized to 10**18
     */
    function get_rates(address _pool) external view returns (uint256[2] memory);

    /**
     * @notice Get balances for each coin within a pool
     * @dev For pools using lending, these are the wrapped coin balances
     * @param _pool Pool address
     * @return uint256 list of balances
     */
    function get_balances(
        address _pool
    ) external view returns (uint256[2] memory);

    /**
     * @notice Get balances for each underlying coin within a metapool
     * @param _pool Metapool address
     * @return uint256 list of underlying balances
     */
    function get_underlying_balances(
        address _pool
    ) external view returns (uint256[8] memory);

    /**
     * @notice Get the amplfication co-efficient for a pool
     * @param _pool Pool address
     * @return uint256 A
     */
    function get_A(address _pool) external view returns (uint256);

    /**
     * @notice Get the fees for a pool
     * @dev Fees are expressed as integers
     * @return Pool fee and admin fee as uint256 with 1e10 precision
     */
    function get_fees(address _pool) external view returns (uint256, uint256);

    /**
     * @notice Get the current admin balances (uncollected fees) for a pool
     * @param _pool Pool address
     * @return List of uint256 admin balances
     */
    function get_admin_balances(
        address _pool
    ) external view returns (uint256[2] memory);

    /**
     * @notice Convert coin addresses to indices for use with pool methods
     * @param _pool Pool address
     * @param _from Coin address to be used as `i` within a pool
     * @param _to Coin address to be used as `j` within a pool
     * @return int128 `i`, int128 `j`, boolean indicating if `i` and `j` are underlying coins
     */
    function get_coin_indices(
        address _pool,
        address _from,
        address _to
    ) external view returns (int128, int128, bool);

    /**
     * @notice Add a base pool to the registry, which may be used in factory metapools
     * @dev Only callable by admin
     * @param _base_pool Pool address to add
     * @param _metapool_implementation Implementation address that can be used with this base pool
     * @param _fee_receiver Admin fee receiver address for metapools using this base pool
     */
    function add_base_pool(
        address _base_pool,
        address _metapool_implementation,
        address _fee_receiver
    ) external;

    /**
     * @notice Deploy a new metapool
     * @param _base_pool Address of the base pool to use within the metapool
     * @param _name Name of the new metapool
     * @param _symbol Symbol for the new metapool - will be concatenated with the base pool symbol
     * @param _coin Address of the coin being used in the metapool
     * @param _A Amplification co-efficient - a higher value here means
     *         less tolerance for imbalance within the pool's assets.
     *         Suggested values include:
     *          * Uncollateralized algorithmic stablecoins: 5-10
     *          * Non-redeemable, collateralized assets: 100
     *          * Redeemable assets: 200-400
     * @param _fee Trade fee, given as an integer with 1e10 precision. The
     *           minimum fee is 0.04% (4000000), the maximum is 1% (100000000).
     *           50% of the fee is distributed to veCRV holders.
     * @return Address of the deployed pool
     */
    function deploy_metapool(
        address _base_pool,
        string memory _name,
        string memory _symbol,
        address _coin,
        uint256 _A,
        uint256 _fee
    ) external returns (address);

    /**
     * @notice Transfer ownership of this contract to `addr`
     * @param addr Address of the new owner
     */
    function commit_transfer_ownership(address addr) external;

    /**
     * @notice Accept a pending ownership transfer
     * @dev Only callable by the new owner
     */
    function accept_transfer_ownership() external;

    /**
     * @notice Set fee receiver for base and plain pools
     * @param _base_pool Address of base pool to set fee receiver for. For plain pools, leave as `ZERO_ADDRESS`.
     * @param _fee_receiver Address that fees are sent to
     */
    function set_fee_receiver(
        address _base_pool,
        address _fee_receiver
    ) external;

    /**
     * @notice Convert the fees of a pool and transfer to the pool's fee receiver
     * @dev All fees are converted to LP token of base pool
     */
    function convert_fees() external returns (bool);

    /**
     * @notice Returns admin address
     * @return Admin address
     */
    function admin() external view returns (address);

    /**
     * @notice Returns future admin address
     * @return Fututre admin address
     */
    function future_admin() external view returns (address);

    /**
     * @notice Returns pool address by index
     * @param arg0 Pool index
     * @return Pool address
     */
    function pool_list(uint256 arg0) external view returns (address);

    /**
     * @notice Returns `pool_list` length
     * @return Pool list length
     */
    function pool_count() external view returns (uint256);

    /**
     * @notice Returns base pool address by index
     * @param arg0 Base pool index
     * @return Base pool address
     */
    function base_pool_list(uint256 arg0) external view returns (address);

    /**
     * @notice Returns `base_pool_list` length
     * @return Base pool list length
     */
    function base_pool_count() external view returns (uint256);

    /**
     * @notice Returns fee reciever by pool address
     * @param arg0 Pool address
     * @return Fee receiver
     */
    function fee_receiver(address arg0) external view returns (address);
}
