// @author - Uwais Kushi-Mohammed
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DEFI is ERC20 {
    constructor() ERC20("DEFI", "DEFI") {}
}