// SPDX-License-Identifier: GPLv2

pragma solidity 0.6.12;

interface IGazeRewards {
    function updateRewards() external returns (bool);
    function LPRewards(uint256 _from, uint256 _to) 
        external 
        view 
        returns (uint256);
    
    function accumulatedLPRewards(uint256 _from, uint256 _to)
        external 
        view 
        returns (uint256);

    function LPRewardsPerBlock() external view returns(uint256);


}
