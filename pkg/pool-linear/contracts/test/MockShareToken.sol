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

import "@balancer-labs/v2-solidity-utils/contracts/test/TestToken.sol";
import "../../../solidity-utils/contracts/test/TestToken.sol";
import "../../../interfaces/contracts/pool-linear/ISilo.sol";
import "../../../interfaces/contracts/pool-linear/IShareToken.sol";

contract MockShareToken is TestToken, IShareToken {
    /// @dev minimal share amount will give us higher precision for shares calculation,
    /// that way losses caused by division will be reduced to acceptable level
    uint256 public constant MINIMUM_SHARE_AMOUNT = 1e5;

    // @notice Silo address of corresponding token
    ISilo public immutable _silo;

    // @notice underlying asset for the shareToken
    address private immutable _underlyingAsset;

    // @notice decimals of shareToken
    // @dev must be equal to underlying asset decimals
    uint8 private immutable _decimals;

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        ISilo silo,
        address underlyingAsset
    ) TestToken(name, symbol, decimals) {
        _silo = silo;
        _underlyingAsset = underlyingAsset;
        _decimals = decimals;
    }

    /// @return decimals that match original asset decimals
    function decimals() public view virtual override(IERC20Metadata, ERC20) returns (uint8) {
        return _decimals;
    }

    function mint(address _account, uint256 _amount) external pure override {

    }

    function burn(address _account, uint256 _amount) external pure override {

    }

}
