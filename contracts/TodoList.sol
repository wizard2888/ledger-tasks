// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title TodoList
/// @notice A simple on-chain task tracker. Each wallet address has its own
///         private list of tasks that only that address can add to or complete.
contract TodoList {
    struct Task {
        uint256 id;
        string content;
        bool completed;
        uint256 createdAt;
    }

    // owner => list of their tasks
    mapping(address => Task[]) private tasks;

    event TaskCreated(address indexed owner, uint256 indexed id, string content);
    event TaskCompleted(address indexed owner, uint256 indexed id);
    event TaskDeleted(address indexed owner, uint256 indexed id);

    /// @notice Add a new task to the caller's list.
    function addTask(string calldata content) external {
        require(bytes(content).length > 0, "Task content cannot be empty");
        require(bytes(content).length <= 280, "Task content too long");

        uint256 newId = tasks[msg.sender].length;
        tasks[msg.sender].push(
            Task({id: newId, content: content, completed: false, createdAt: block.timestamp})
        );

        emit TaskCreated(msg.sender, newId, content);
    }

    /// @notice Mark one of the caller's tasks as completed.
    function completeTask(uint256 id) external {
        require(id < tasks[msg.sender].length, "Task does not exist");
        require(!tasks[msg.sender][id].completed, "Task already completed");

        tasks[msg.sender][id].completed = true;
        emit TaskCompleted(msg.sender, id);
    }

    /// @notice Remove a task by clearing its content (keeps ids stable).
    function deleteTask(uint256 id) external {
        require(id < tasks[msg.sender].length, "Task does not exist");

        delete tasks[msg.sender][id];
        emit TaskDeleted(msg.sender, id);
    }

    /// @notice Get all tasks belonging to a given address.
    function getTasks(address owner) external view returns (Task[] memory) {
        return tasks[owner];
    }

    /// @notice Convenience: get the caller's own tasks.
    function getMyTasks() external view returns (Task[] memory) {
        return tasks[msg.sender];
    }

    /// @notice How many tasks an address has created in total.
    function taskCount(address owner) external view returns (uint256) {
        return tasks[owner].length;
    }
}
