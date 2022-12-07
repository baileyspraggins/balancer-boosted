// SPDX-License-Identifier: GPL-3.0-or-later
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "@balancer-labs/v2-interfaces/contracts/pool-linear/IStaticAToken.sol";
import "@balancer-labs/v2-interfaces/contracts/pool-utils/ILastCreatedPoolFactory.sol";
import "@balancer-labs/v2-solidity-utils/contracts/openzeppelin/SafeERC20.sol";

import "../LinearPoolRebalancer.sol";
import "../../../interfaces/contracts/pool-linear/ISilo.sol";

contract SiloLinearPoolRebalancer is LinearPoolRebalancer {
    using SafeERC20 for IERC20;

    // These Rebalancers can only be deployed from a factory to work around a circular dependency: the Pool must know
    // the address of the Rebalancer in order to register it, and the Rebalancer must know the address of the Pool
    // during construction.
    constructor(IVault vault, IBalancerQueries queries)
        LinearPoolRebalancer(ILinearPool(ILastCreatedPoolFactory(msg.sender).getLastCreatedPool()), vault, queries)
    {
        // solhint-disable-previous-line no-empty-blocks
    }

    function _wrapTokens(uint256 amount) internal override {
        // @dev In order to receive a sharesToken that can gain interest false must be entered for collateralOnly
        // deposit however, we need to approve the wrapper in the underlying token.
        _mainToken.safeApprove(address(_wrappedToken), amount);
        ISilo(address(_wrappedToken)).deposit(address(this), amount, false);

    }

    function _unwrapTokens(uint256 amount) internal override {
        // Withdrawing into underlying (i.e. DAI, USDC, etc. instead of sDAI or sUSDC). Approvals are not necessary here
        // as the wrapped token is simply burnt.
        ISilo(address(_wrappedToken)).withdraw(address(this), amount, false);

    }

    function _getRequiredTokensToWrap(uint256 wrappedAmount) internal view override returns (uint256) {
        // Get the silo associated with the wrappedToken
        ISilo silo = ISilo(IShareToken(address(_wrappedToken)).silo());

        // @dev value hardcoding to find the exchange rate for a single _shareToken
        uint256 singleShare = 1e18;
        // @dev total amount deposited
        uint256 totalAmount = silo.assetStorage(_shareToken).totalDeposits;
        // @dev total number of shares
        uint256 totalShares = silo.assetStorage(_shareToken).collateralToken;
        // This is how
        uint256 rate = toAmount(singleShare, totalAmount, totalShares);

        return rate * wrappedAmount;
    }

}
