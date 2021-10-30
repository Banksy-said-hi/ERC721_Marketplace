ragma solidity 0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract NFTTrader {
    
    mapping(address => mapping(uint => Listing)) public listings;
    mapping(address => uint) public balances;
    
    struct Listing {
        uint price;
        address seller;
    }
    
    
    // ===========================================================
    // Seller before clicking this method has to approve the address of this contract to let it transfer 
    // the sold tokens whenever the payment is done by the buyer
    
    function addListing(uint _price, address _contractAddress, uint _tokenId) public {
        
        ERC721 token = ERC721(_contractAddress);
        require(token.ownerOf(_tokenId) == msg.sender, "Calller must own given token");
        require(token.getApproved(_tokenId) == address(this), "The marketplace is not approved yet by the owner");
        
        listings[_contractAddress][_tokenId] = Listing( _price, msg.sender);
    }
    
    

    function purchase(address _contractAddress, uint _tokenId) public payable {
        
        Listing memory item = listings[_contractAddress][_tokenId];
        require(msg.value >= item.price, "Insufficient funds sent");
        balances[item.seller] += msg.value;
        
        ERC721 token = ERC721(_contractAddress);
        token.safeTransferFrom(item.seller, msg.sender, _tokenId);
        
    }    
    
    
    
    
    function withdraw(uint _amount, address payable _destinationAddress) public {
        require(_amount <= balances[msg.sender], "You are trying to withdraw more than you have in the contract");
        
        balances[msg.sender] -= _amount;
        _destinationAddress.transfer(_amount);
    }
}   

