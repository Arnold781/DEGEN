// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error INSUFFICIENT_DEGEN();

contract AstroWorld is ERC20, Ownable {

    enum GameItems { PlantGrowthChamber, OrigamiKit, DrawingSupplies, ComputerSoftware }

    // Mapping to store user inventories
    mapping(address => GameItems[]) private userInventories;

    constructor() ERC20("Degen", "DGN") Ownable() {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function TransferDegen(address _receiver, uint256 _amount) external returns (bool success) {
        if (_amount > balanceOf(msg.sender)) {
            revert INSUFFICIENT_DEGEN();
        }
        success = transfer(_receiver, _amount);
    }

    function burn(uint256 _amount) external {
        if (_amount > balanceOf(msg.sender)) {
            revert INSUFFICIENT_DEGEN();
        }
        _burn(msg.sender, _amount);
    }

    function getDegenBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function redeemItems(GameItems _item) external {
        uint256 itemValue = getItemValue(_item);

        if (itemValue > balanceOf(msg.sender)) {
            revert INSUFFICIENT_DEGEN();
        }

        _transfer(msg.sender, address(this), itemValue);

        // Add item to user's inventory
        userInventories[msg.sender].push(_item);
    }

    function getItemValue(GameItems _item) internal pure returns (uint256) {
        if (_item == GameItems.PlantGrowthChamber) {
            return 8 * 1e18;
        } else if (_item == GameItems.OrigamiKit) {
            return 6 * 1e18;
        } else if (_item == GameItems.DrawingSupplies) {
            return 4 * 1e18;
        } else if (_item == GameItems.ComputerSoftware) {
            return 2 * 1e18;
        } else {
            return 0;
        }
    }

    function getUserInventory(address user) external view returns (GameItems[] memory) {
        return userInventories[user];
    }

    function withdrawDegenFunds() external onlyOwner {
        _transfer(address(this), msg.sender, balanceOf(address(this)));
    }
}
