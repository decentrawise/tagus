pragma solidity ^0.4.19;

contract TagUsTransaction {
  

  struct Delivery {
    bool available;
    uint32 distance;            //  Measured in meters
    uint16 reservationBlocks;   //  The maximum number of blocks for this reservation 
  }

  struct Pickup {
    bool available;
    uint256 reservationBlocks;            //  The maximum number of blocks for this reservation 
  }


  struct Reserve {
    address consumer;
    uint32 quantity;         //  Amount of product reserved
    uint amount;             //  Amount of tokens reserved
    uint256 expirationBlock; //  Block id that overdues this reserve
  }

  struct Offer {
    uint16 id;              //  Id for this offer

    //  Product details
    string title;           //  A title/name for the product
    string category;        //  Category which this product belongs
    string description;     //  Text description of the product
    string photoURL;        //  URL for a photo description of the product
    uint16 expirationBlock; //  Last block that this offer is available

    //  Supply
    uint32 quantity;
    string unit;
    uint64 price;           //  Unit price

    //  Fees
    uint cancellation;      //  Defines the cancellation fee for this offer
    uint publishing;        //  Defines the extra publishing fee for this offer
    
    mapping (address => Reserve) pickups;
    mapping (address => Reserve) deliveries;
  }
  
  
  struct Provider {
    address id;
    string name;
    string streetAddress;
    string contact;
    uint32 latitude;
    uint32 longitude;

    Delivery delivery;
    Pickup pickup;
    
    uint16 lastOfferId;
    mapping (uint16 => Offer) offers;
  }
  

  mapping (address => Provider) providers;

  constructor() public payable {
      
  }
  

  //  TODO: All the contract functions are using way too much gas, so this requires 
  //  TODO: We need a good identification of the users (providers and consumers) to pass as method parameters
  
  function registerProfile(string name, string streetAddress, string contact, uint32 latitude, uint32 longitude) public {
        Provider memory provider = Provider( msg.sender, name, streetAddress, contact, latitude, longitude,
                                             Delivery(true, 10, 50),
                                             Pickup(true, 60),
                                             0
                                           );
        providers[msg.sender] = provider;

  }
  
  function publishOffer(string title, string description, uint32 quantity) public returns (uint16 offerId) {
    
    //  TODO: validate the existance of the provider...for now, assume it exists
    Provider storage provider = providers[msg.sender];
    
    Offer memory offer = Offer( provider.lastOfferId,
                                title, "<category>", description, "http://someimage.png", 60,   //  Product details
                                quantity, "kg", 100,
                                10, 10
                              );
    
    provider.offers[provider.lastOfferId] = offer;
    provider.lastOfferId++;
    
    return offer.id;

  }
  
  function instantPurchase(address providerId, uint16 offerId, uint32 quantity) public payable {
    
    //  TODO: validate the existance of the provider and the offer...for now, assume they both exist
    Provider storage provider = providers[providerId];
    Offer storage offer = provider.offers[offerId];
    
    if(offer.id == 0) {
        //  TODO: throw 'Offer doesn't exist''
        return;
    }
    
    delete provider.offers[offerId];    //  Avoid reentrancy
    
    if( offer.quantity < quantity ) {
        //  TODO: throw an error 'Not enough units to sell'
        provider.offers[offerId] = offer;
        return;
    }
    
    if( offer.price * quantity != msg.value ) {
        //  TODO: throw an error 'Invalid transfer value'
        provider.offers[offerId] = offer;
        return;
    }
    
    
    //  TODO: transfer may throw...need to deal with the exception
    provider.id.transfer(msg.value);
    offer.quantity -= quantity;
        
    //  If there still are units in the offer, keep it
    if( offer.quantity > 0 ) {
        provider.offers[offerId] = offer;
        return;
    }

  }
  
  function reserveForPickup(address providerId, uint16 offerId, uint32 quantity, uint16 pickupTime) public payable {

    //  TODO: validate the existance of the provider and the offer...for now, assume they both exist
    Provider storage provider = providers[providerId];
    Offer storage offer = provider.offers[offerId];
    
    
    //  TODO: throw an error 'reservation already exists for this product'

    if( offer.quantity < quantity ) {
        //  TODO: throw an error 'Not enough units to sell'
    }
    
    //  Reserve quantity
    offer.quantity += quantity;
    
    if( offer.price * quantity != msg.value ) {
        //  TODO: throw an error 'Invalid transfer value'
    }
    
    Reserve memory reserve = Reserve(msg.sender, quantity, msg.value, now + pickupTime);

    offer.pickups[msg.sender] = reserve;
  }
  
  
  function acceptPickup(address providerId, uint16 offerId) public {

    //  TODO: validate the existance of the provider and the offer...for now, assume they both exist
    Provider storage provider = providers[providerId];
    Offer storage offer = provider.offers[offerId];
    Reserve memory pickup = offer.pickups[msg.sender];
    
    if( pickup.consumer == address(0) ) {
        //  Throw error 'Pickup not found';
        return;
    }
    
    delete offer.pickups[msg.sender];   //  Avoid reentrancy
    
    //  TODO: transfer may throw...need to deal with the exception
    provider.id.transfer(pickup.amount);
    
    //  TODO: if transfer throws, then re-insert the pickup into the map
    
  }
  

}
