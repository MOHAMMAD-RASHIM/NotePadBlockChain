// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Notepad {
    // Struct to represent a file
    struct File {
        uint256 id;
        string content;
        address owner;
        bool exists;
    }
    
    // Mapping to store files by ID
    mapping(uint256 => File) private files;
    
    // Array to store all file IDs
    uint256[] private fileIds;
    
    // Counter for total number of documents
    uint256 private documentCount;
    
    // Event emitted when a file is created
    event FileCreated(uint256 indexed id, address indexed owner, string content);
    
    // Event emitted when a file is updated
    event FileUpdated(uint256 indexed id, address indexed owner, string content);
    
    // Modifier to check if file exists
    modifier fileExists(uint256 _id) {
        require(files[_id].exists, "File does not exist");
        _;
    }
    
    // Function to create a new file
    function createFile(uint256 _id, string memory _content) public {
        require(!files[_id].exists, "File ID already exists");
        
        files[_id] = File({
            id: _id,
            content: _content,
            owner: msg.sender,
            exists: true
        });
        
        fileIds.push(_id);
        documentCount++;
        
        emit FileCreated(_id, msg.sender, _content);
    }
    
    // Function to update existing file content
    function updateFile(uint256 _id, string memory _content) public fileExists(_id) {
        require(files[_id].owner == msg.sender, "Only owner can update file");
        
        files[_id].content = _content;
        
        emit FileUpdated(_id, msg.sender, _content);
    }
    
    // Function to retrieve file content
    function getFile(uint256 _id) public view fileExists(_id) returns (uint256, string memory, address) {
        File memory file = files[_id];
        return (file.id, file.content, file.owner);
    }
    
    // Function to get total document count
    function getDocumentCount() public view returns (uint256) {
        return documentCount;
    }
    
    // Function to get list of all file IDs
    function getFileIds() public view returns (uint256[] memory) {
        return fileIds;
    }
}
