// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// OAPS Pilot: Demonstration of the State Machine pattern
// Reference: https://github.com/fravoll/solidity-patterns/blob/master/StateMachine.sol
// Purpose: To have an immutable OAPS proof for a State Machine implementation.

contract StateMachinePilot {
    enum Stage { Draft, Active, Paused, Terminated }
    
    Stage public currentStage = Stage.Draft;
    address public owner = msg.sender;
    
    modifier atStage(Stage _stage) {
        require(currentStage == _stage, "Function cannot be called at current stage");
        _;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    // Transition: Draft -> Active (only owner)
    function activate() external onlyOwner atStage(Stage.Draft) {
        currentStage = Stage.Active;
    }
    
    // Transition: Active <-> Paused (only owner)
    function pause() external onlyOwner atStage(Stage.Active) {
        currentStage = Stage.Paused;
    }
    
    function resume() external onlyOwner atStage(Stage.Paused) {
        currentStage = Stage.Active;
    }
    
    // Transition: Any -> Terminated (only owner)
    function terminate() external onlyOwner {
        require(currentStage != Stage.Terminated, "Already terminated");
        currentStage = Stage.Terminated;
    }
    
    // Helper view function
    function getStage() external view returns (string memory) {
        if (currentStage == Stage.Draft) return "Draft";
        if (currentStage == Stage.Active) return "Active";
        if (currentStage == Stage.Paused) return "Paused";
        return "Terminated";
    }
}
