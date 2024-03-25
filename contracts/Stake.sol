// SPDX-License-Identifier: MIT
// @author - Uwais Kushi-Mohammed
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DEFI is ERC20 {
    
    mapping(address => uint256) stakedAmount;
    mapping(address => uint256) stakedTimestamp;
    
    constructor() ERC20("DEFI", "DEFI") {
        // total supply as 1M DEFI tokens
        _mint(msg.sender, 1000000);
    }

    function stake(uint256 amount) public {
        // ensure user has enough to stake
        require(amount > 0, "You cannot stake 0 tokens");
        require(balanceOf(msg.sender) >= amount, "You do not have enough tokens");

        // update mapping
        stakedAmount[msg.sender] += amount;

        // only record the timestamp when amount exceeds 1000 which is when the rewards should 
        // start being calculated from
        if (stakedTimestamp[msg.sender] == 0 && stakedAmount[msg.sender] >= 1000) {
            stakedTimestamp[msg.sender] = block.timestamp;
        }

       // transfer to the contracts address
        _transfer(msg.sender, address(this), amount);

    }

    function claim() public {
        require(stakedAmount[msg.sender] > 0, "You have no tokens staked");

        uint256 totalStaked = stakedAmount[msg.sender];

        uint256 rewardPerThousandTokens = 1 * (totalStaked / 1000);
        // get reward into days
        uint256 daysElapsed = (block.timestamp - stakedTimestamp[msg.sender]) / 864000;
        uint256 reward = rewardPerThousandTokens * daysElapsed;
        
        uint256 rewardPlusOriginal = reward + stakedAmount[msg.sender];

        // transfer this amount from the supply to the staker
        require(balanceOf(address(this)) >= rewardPlusOriginal, "contract doesn't have enough");
        _transfer(address(this), msg.sender, rewardPlusOriginal);

        // update the mappings
        stakedAmount[msg.sender] = 0;
        stakedTimestamp[msg.sender] = 0;
    }

    function viewRewards() public view returns(uint256) {
        
        uint256 totalStaked = stakedAmount[msg.sender];

        uint256 rewardPerThousandTokens = 1 * (totalStaked / 1000);
        // get reward into days
        uint256 daysElapsed = (block.timestamp - stakedTimestamp[msg.sender]) / 864000;

        return rewardPerThousandTokens * daysElapsed;
    }


}