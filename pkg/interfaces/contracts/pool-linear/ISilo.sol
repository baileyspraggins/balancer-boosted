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

pragma solidity >=0.7.0 <0.9.0;

import "../solidity-utils/openzeppelin/IERC20.sol";
import "./IBaseSilo.sol";

interface ISilo is IBaseSilo {

    /**
     * @dev returns the address of the silos asset (underlying/main token)
     */
    function siloAsset() external view returns (address);

    /**
     * @dev returns the assets decimal points
     * @dev TODO: Find out how many fixed decimal points function returns
     */
    function ASSET_DECIMAL_POINTS() external view returns (uint256);

    /**
     * @dev Deposits funds into the Silo
     * @param _collateralOnly: True means your shareToken is protected (cannot be swapped for interest)
     */
    function deposit(address _asset, uint256 _amount, bool _collateralOnly) external nonpayable;

    /**
     * @dev Withdraws funds from the Silo
     * @param _collateralOnly: True means your shareToken is protected (cannot be swapped for interest)
     */
    function withdraw(address _asset, uint256 _amount, bool _collateralOnly) external nonpayable;

}
