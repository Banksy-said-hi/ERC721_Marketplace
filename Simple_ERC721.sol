pragma solidity 0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    
    constructor() ERC721("Ticket", "DTC") {}
    
    uint public tokenId;
    
    function mint() public {
        _safeMint(msg.sender, tokenId);
        tokenId += 1;
    }
    
    function burn(uint _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender, "The caller must be the owner!");
        _burn(_tokenId);
    }
}
