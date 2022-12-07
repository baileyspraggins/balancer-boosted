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

import "../solidity-utils/openzeppelin/IERC20Metadata.sol";
import "./ISilo.sol";

interface IShareToken is IERC20Metadata {

    /**
     * @dev returns the underlying asset
    */
    function asset() external view returns (address);

    /**
      * @dev returns the address of the silo
    */
    function silo() external view returns (ISilo);

    /**
      * @dev returns the number of decimals for the token
      * @dev shareTokens will always have the same number of decimals as their underlying asset
    */
    function decimals() external view returns (uint8);

    /**
     * @dev Mint sToken to wallet
     * @param _account: wallet which tokens will mint to
     * @param _amount: How many sTokens to mint
    */
    function mint(address _account, uint256 _amount) external nonpayable;

    /**
     * @dev Mint sToken to wallet
     * @param _account: wallet which to burn sTokens from
     * @param _amount: How many sTokens to burn
    */
    function burn(address _account, uint256 _amount) external nonpayable;

}