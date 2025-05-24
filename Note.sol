// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Notepad {
    struct File {
        string content;
        address owner;
    }

    mapping(uint256 => File) private files;
    uint256[] private fileIds;

    // Event declarations
    event FileCreated(uint256 indexed id, address indexed owner, string content);
    event FileUpdated(uint256 indexed id, address indexed owner, string content);

    // Modifier to check file existence
    modifier fileExists(uint256 _id) {
        require(files[_id].owner != address(0), "File does not exist");
        _;
    }

    function createFile(uint256 _id, string calldata _content) external {
        require(files[_id].owner == address(0), "File ID already exists");

        files[_id] = File(_content, msg.sender);
        fileIds.push(_id);

        emit FileCreated(_id, msg.sender, _content);
    }

    function updateFile(uint256 _id, string calldata _content) external fileExists(_id) {
        require(files[_id].owner == msg.sender, "Only owner can update file");

        files[_id].content = _content;

        emit FileUpdated(_id, msg.sender, _content);
    }

    function getFile(uint256 _id) external view fileExists(_id) returns (string memory, address) {
        File storage file = files[_id];
        return (file.content, file.owner);
    }

    function getDocumentCount() external view returns (uint256) {
        return fileIds.length;
    }

    function getFileIds() external view returns (uint256[] memory) {
        return fileIds;
    }
}
