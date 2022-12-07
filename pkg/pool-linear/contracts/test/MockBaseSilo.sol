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

import "@balancer-labs/v2-pool-utils/contracts/test/MaliciousQueryReverter.sol";
import "../silo/SiloHelpers.sol";
import "../../../interfaces/contracts/pool-linear/IBaseSilo.sol";

contract MockBaseSilo is IBaseSilo {

    // asset address for which Silo was created
    address public immutable _siloAsset;

    /// @dev asset => AssetStorage
    mapping(address => AssetStorage) private _assetStorage;

    // solhint-disable-next-line var-name-mixedcase
    uint256 private immutable _ASSET_DECIMAL_POINTS;

    error NotSolvent();
    error NotEnoughDeposits();
    error NotEnoughLiquidity();

    constructor (address siloAsset) {
        _siloAsset = siloAsset;
    }

    function assetStorage(address _asset) external view override returns (AssetStorage memory) {
        return _assetStorage;
    }

    function _siloAsset() external view returns (address) {
        return _siloAsset;
    }

    function _setAssetStorage(
        IShareToken collateralToken,
        IShareToken collateralOnlyToken,
        IShareToken debtToken,
        uint256 totalDeposits,
        uint256 collateralOnlyDeposits,
        uint256 totalBorrowAmount) external {

        _assetStorage = AssetStorage(collateralToken, collateralOnlyToken, debtToken, totalDeposits, collateralOnlyDeposits, totalBorrowAmount);
    }

    function _deposit(
        address _asset,
        address _from,
        address _depositor,
        uint256 _amount,
        bool _collateralOnly
    )
    internal
    returns (uint256 collateralAmount, uint256 collateralShare) {
        AssetStorage storage _state = _assetStorage[_asset];

        collateralAmount = _amount;

        uint256 totalDepositsCached = _collateralOnly ? _state.collateralOnlyDeposits : _state.totalDeposits;

        if (_collateralOnly) {
            collateralShare = _amount.toShare(totalDepositsCached, _state.collateralOnlyToken.totalSupply());
            _state.collateralOnlyDeposits = totalDepositsCached + _amount;
            _state.collateralOnlyToken.mint(_depositor, collateralShare);
        } else {
            collateralShare = _amount.toShare(totalDepositsCached, _state.collateralToken.totalSupply());
            _state.totalDeposits = totalDepositsCached + _amount;
            _state.collateralToken.mint(_depositor, collateralShare);
        }
    }

    function _withdraw(address _asset, address _depositor, address _receiver, uint256 _amount, bool _collateralOnly)
    internal
    returns (uint256 withdrawnAmount, uint256 withdrawnShare)
    {
        (withdrawnAmount, withdrawnShare) = _withdrawAsset(
            _asset,
            _amount,
            _depositor,
            _receiver,
            _collateralOnly,
            0 // do not apply any fees on regular withdraw
        );

        if (!isSolvent(_depositor)) revert NotSolvent();

    }

    function _withdrawAsset(
        address _asset,
        uint256 _assetAmount,
        address _depositor,
        address _receiver,
        bool _collateralOnly,
        uint256 _protocolLiquidationFee
    )
    internal
    returns (uint256 withdrawnAmount, uint256 burnedShare)
    {
        (uint256 assetTotalDeposits, IShareToken shareToken, uint256 availableLiquidity) =
        _getWithdrawAssetData(_asset, _collateralOnly);

        if (_assetAmount == type(uint256).max) {
            burnedShare = shareToken.balanceOf(_depositor);
            withdrawnAmount = burnedShare.toAmount(assetTotalDeposits, shareToken.totalSupply());
        } else {
            burnedShare = _assetAmount.toShareRoundUp(assetTotalDeposits, shareToken.totalSupply());
            withdrawnAmount = _assetAmount;
        }

        if (withdrawnAmount == 0) {
            // we can not revert here, because liquidation will fail when one of collaterals will be empty
            return (0, 0);
        }

        if (assetTotalDeposits < withdrawnAmount) revert NotEnoughDeposits();

        unchecked {
            // can be unchecked because of the `if` above
            assetTotalDeposits -=  withdrawnAmount;
        }

        uint256 amountToTransfer = withdrawnAmount;

        if (availableLiquidity < amountToTransfer) revert NotEnoughLiquidity();

        AssetStorage storage _state = _assetStorage[_asset];

        if (_collateralOnly) {
            _state.collateralOnlyDeposits = assetTotalDeposits;
        } else {
            _state.totalDeposits = assetTotalDeposits;
        }

        shareToken.burn(_depositor, burnedShare);
        // in case token sent in fee-on-transfer type of token we do not care when withdrawing
        ERC20(_asset).safeTransfer(_receiver, amountToTransfer);
    }

}
