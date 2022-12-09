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

import "@balancer-labs/v2-pool-utils/contracts/test/MaliciousQueryReverter.sol";
import "@balancer-labs/v2-interfaces/contracts/pool-linear/IShareToken.sol";
import "../silo/SiloHelpers.sol";
import "@balancer-labs/v2-interfaces/contracts/pool-linear/ISilo.sol";

contract MockBaseSilo is IBaseSilo {
    // asset address for which Silo was created
    address public immutable _siloAsset;

    /// @dev asset => AssetStorage
    mapping(address => AssetStorage) private _assetStorage;

    // // solhint-disable-next-line var-name-mixedcase
    // uint256 private immutable _ASSET_DECIMAL_POINTS;

    constructor(address siloAsset) {
        _siloAsset = siloAsset;
    }

    function assetStorage(address _asset) external view override returns (AssetStorage memory) {
        AssetStorage memory assetMapping = _assetStorage[_asset];
        return assetMapping;
    }

    function siloAsset() external view returns (address) {
        return _siloAsset;
    }

    function setAssetStorage(
        address interestBarringAsset,
        IShareToken collateralToken,
        IShareToken collateralOnlyToken,
        IShareToken debtToken,
        uint256 totalDeposits,
        uint256 collateralOnlyDeposits,
        uint256 totalBorrowAmount
    ) external {
        AssetStorage memory storageValue = AssetStorage(
            collateralToken,
            collateralOnlyToken,
            debtToken,
            totalDeposits,
            collateralOnlyDeposits,
            totalBorrowAmount
        );

        _assetStorage[interestBarringAsset] = storageValue;
    }

    // function _deposit(
    //     address _asset,
    //     address _from,
    //     address _depositor,
    //     uint256 _amount,
    //     bool _collateralOnly
    // ) internal returns (uint256 collateralAmount, uint256 collateralShare) {
    //     AssetStorage storage _state = _assetStorage[_asset];

    //     collateralAmount = _amount;

    //     uint256 totalDepositsCached = _collateralOnly ? _state.collateralOnlyDeposits : _state.totalDeposits;

    //     if (_collateralOnly) {
    //         collateralShare = SiloHelpers.toShare(
    //             _amount,
    //             totalDepositsCached,
    //             _state.collateralOnlyToken.totalSupply()
    //         );
    //         _state.collateralOnlyDeposits = totalDepositsCached + _amount;
    //         _state.collateralOnlyToken.mint(_depositor, collateralShare);
    //     } else {
    //         collateralShare = SiloHelpers.toShare(_amount, totalDepositsCached, _state.collateralToken.totalSupply());
    //         _state.totalDeposits = totalDepositsCached + _amount;
    //         _state.collateralToken.mint(_depositor, collateralShare);
    //     }
    // }

    // function _withdraw(
    //     address _asset,
    //     address _depositor,
    //     address _receiver,
    //     uint256 _amount,
    //     bool _collateralOnly
    // ) internal returns (uint256 withdrawnAmount, uint256 withdrawnShare) {
    //     (withdrawnAmount, withdrawnShare) = _withdrawAsset(
    //         _asset,
    //         _amount,
    //         _depositor,
    //         _receiver,
    //         _collateralOnly,
    //         0 // do not apply any fees on regular withdraw
    //     );
    // }

    // function _withdrawAsset(
    //     address _asset,
    //     uint256 _assetAmount,
    //     address _depositor,
    //     address _receiver,
    //     bool _collateralOnly,
    //     uint256 _protocolLiquidationFee
    // ) internal returns (uint256 withdrawnAmount, uint256 burnedShare) {
    //     (uint256 assetTotalDeposits, IShareToken shareToken, uint256 availableLiquidity) = _getWithdrawAssetData(
    //         _asset,
    //         _collateralOnly
    //     );

    //     if (_assetAmount == type(uint256).max) {
    //         burnedShare = shareToken.balanceOf(_depositor);
    //         withdrawnAmount = SiloHelpers.toAmount(burnedShare, assetTotalDeposits, shareToken.totalSupply());
    //     } else {
    //         burnedShare = SiloHelpers.toShareRoundUp(_assetAmount, assetTotalDeposits, shareToken.totalSupply());
    //         withdrawnAmount = _assetAmount;
    //     }

    //     if (withdrawnAmount == 0) {
    //         // we can not revert here, because liquidation will fail when one of collaterals will be empty
    //         return (0, 0);
    //     }

    //     if (assetTotalDeposits < withdrawnAmount) revert("NotEnoughDeposits");

    //     // Wrapped with unchecked in source code
    //     assetTotalDeposits -= withdrawnAmount;

    //     uint256 amountToTransfer = withdrawnAmount;

    //     if (availableLiquidity < amountToTransfer) revert("NotEnoughLiquidity");

    //     AssetStorage storage _state = _assetStorage[_asset];

    //     if (_collateralOnly) {
    //         _state.collateralOnlyDeposits = assetTotalDeposits;
    //     } else {
    //         _state.totalDeposits = assetTotalDeposits;
    //     }

    //     shareToken.burn(_depositor, burnedShare);
    //     // in case token sent in fee-on-transfer type of token we do not care when withdrawing
    //     IERC20(_asset).transfer(_receiver, amountToTransfer);
    // }

    // function _getWithdrawAssetData(
    //     address _asset,
    //     bool _collateralOnly
    // ) private view returns (uint256 assetTotalDeposits, IShareToken shareToken, uint256 availableLiquidity) {
    //     AssetStorage storage _state = _assetStorage[_asset];

    //     if (_collateralOnly) {
    //         assetTotalDeposits = _state.collateralOnlyDeposits;
    //         shareToken = _state.collateralOnlyToken;
    //         availableLiquidity = assetTotalDeposits;
    //     } else {
    //         assetTotalDeposits = _state.totalDeposits;
    //         shareToken = _state.collateralToken;
    //         availableLiquidity = liquidity(_asset);
    //     }
    // }

    // function liquidity(address _asset) public view returns (uint256) {
    //     return IERC20(_asset).balanceOf(address(this)) - _assetStorage[_asset].collateralOnlyDeposits;
    // }
}
