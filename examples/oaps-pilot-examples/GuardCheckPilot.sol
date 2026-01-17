// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// OAPS Pilot: Demonstration of the Guard Check pattern
// Reference: https://github.com/fravoll/solidity-patterns/blob/master/GuardCheck.sol
// Purpose: To have an immutable OAPS proof validating the implementation of a fundamental security pattern.

contract GuardCheckPilot {
    uint256 public constant ENTRY_FEE = 0.01 ether;
    uint256 public totalParticipants;
    
    mapping(address => bool) public hasParticipated;
    
    // GUARD CHECK: Validate payment amount before proceeding
    function participate() external payable {
        require(msg.value == ENTRY_FEE, "GuardCheck: Incorrect payment amount");
        require(!hasParticipated[msg.sender], "GuardCheck: Already participated");
        
        // Effects
        hasParticipated[msg.sender] = true;
        totalParticipants += 1;
        
        // Interactions (hypothetical - could mint NFT, etc.)
        // ... additional logic here
    }
    
    // Additional guard check example for owner-only function
    address public owner = msg.sender;
    modifier onlyOwner() {
        require(msg.sender == owner, "GuardCheck: Caller is not owner");
        _;
    }
    
    function withdrawFees() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
