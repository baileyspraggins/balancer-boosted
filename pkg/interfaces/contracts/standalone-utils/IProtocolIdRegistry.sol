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

/**
 * @dev Registry of protocol IDs for external integrations with Balancer. The IDs chosen are arbitrary and do not affect
 * behavior of any Balancer contracts. They are used only to tag specific contracts (usually pools) at the data layer.
 */
interface IProtocolIdRegistry {
    // Emitted when a new protocol ID is registered.
    event ProtocolIdRegistered(uint256 indexed protocolId, string name);

    /**
     * @dev Registers an ID (and name) to differentiate among protocols. Protocol IDs cannot be deregistered.
     */
    function registerProtocolId(uint256 protocolId, string memory name) external;

    /**
     * @dev Returns true if `protocolId` has been registered and can be queried.
     */
    function isValidProtocolId(uint256 protocolId) external view returns (bool);

    /**
     * @dev Returns the name associated with a given `protocolId`.
     */
    function getProtocolName(uint256 protocolId) external view returns (string memory);
}

library ProtocolId {
    // This list is not exhaustive - more protocol IDs can be added to the system. It is expected for this list to be
    // extended with new protocol IDs as they are registered, to keep them all in one place and reduce
    // likelihood of user error.
    // solhint-disable private-vars-leading-underscore
    uint256 internal constant AAVE_V1 = 0;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant AAVE_V2 = 1;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant AAVE_V3 = 2;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant AURA = 3;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant BEEFY = 4;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant BEETHOVEN = 5;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant BUTTONWOOD = 6;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant COW = 7;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant CRON = 8;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant ELEMENT = 9;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant EULER = 10;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant FJORD = 11;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant GEARBOX = 12;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant GYROSCOPE = 13;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant ONEINCH = 14;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant MYCELIUM = 15;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant PARASWAP = 16;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant POWERPOOL = 17;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant PRIMEDAO = 18;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant REAPER = 19;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant SENSE = 20;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant SILO = 21;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant STAKEDAO = 22;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant STARGATE = 23;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant TETU = 24;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant TEMPUS = 25;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant XAVE = 26;
    // solhint-enable private-vars-leading-underscore
    uint256 internal constant YEARN = 27;
}
