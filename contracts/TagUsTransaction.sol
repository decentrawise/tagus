pragma solidity ^0.4.24;

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
        uint256 expirationBlock; //  Last block that this offer is available

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

    event ProfilePublished(address providerAddr, string providerName, string streetAddress, string contact, uint32 longitude, uint32 latitude);
    event OfferPublished(address providerAddr, uint16 offerId, string providerName, string title, string category, uint256 expirationBlock, uint32 longitude, uint32 latitude);
    event Message(string message);
    event Message2(string message, uint a1, uint a2);
    
    //  TODO: All the contract functions are using way too much gas, so this requires 
    //  TODO: We need a good identification of the users (providers and consumers) to pass as method parameters

    function ping() public {
        emit Message("Pong");
    }

    function registerProfile(string name, string streetAddress, string contact, uint32 latitude, uint32 longitude) public {

        //  TODO: Verify if the profile already exists...this is not working even if no errors are logged
        if(providers[msg.sender].id != address(0)) {
            emit Message("Profile already exists.");
            return;
        }

        Provider memory provider = Provider( msg.sender, name, streetAddress, contact, latitude, longitude,
                                             Delivery(true, 10, 50),
                                             Pickup(true, 60),
                                             0
                                           );
        providers[msg.sender] = provider;

        emit ProfilePublished(provider.id, provider.name, provider.streetAddress, provider.contact, provider.longitude, provider.latitude);
    }

    function publishOffer(string title, string description, uint32 quantity) public returns (uint16 offerId) {

        Provider storage provider = providers[msg.sender];

        //  Validate if the provider exists
        if(provider.id == address(0)) {
            emit Message("Provider doesn't exist");
            return 0;
        }

        Offer memory offer = Offer( ++provider.lastOfferId,
                                    title, "<category>", description, "http://someimage.png", now + 600,   //  Product details
                                    quantity, "kg", 100,
                                    10, 10
                                  );

        provider.offers[provider.lastOfferId] = offer;

        emit OfferPublished(provider.id, offer.id, provider.name, offer.title, offer.category, offer.expirationBlock, provider.longitude, provider.latitude);

        return offer.id;
    }

    function instantPurchase(address providerId, uint16 offerId, uint32 quantity) public payable {

        //  TODO: validate the existance of the provider and the offer...for now, assume they both exist
        Provider storage provider = providers[providerId];
        Offer storage offer = provider.offers[offerId];

        //  TODO: Avoid reentrancy

        if(offer.id == 0) {
            emit Message("There is no offer with this provider/offer ids");
            return;
        }

        if( offer.quantity < quantity ) {
            emit Message2("Not enough units to sell [available, wanted]", offer.quantity, quantity);
            return;
        }

        if( offer.price * quantity != msg.value ) {
            emit Message2("Invalid transfer value [price, payed]", offer.price * quantity, msg.value);
            provider.offers[offerId] = offer;
            return;
        }


        //  TODO: transfer may throw...need to deal with the exception
        provider.id.transfer(msg.value);
        offer.quantity -= quantity;

        //  If there still are units in the offer, keep it
        if( offer.quantity == 0 ) {
            delete provider.offers[offerId];
        }

    }

    function reserveForPickup(address providerId, uint16 offerId, uint32 quantity, uint16 pickupTime) public payable {

        //  TODO: validate the existance of the provider and the offer...for now, assume they both exist
        Provider storage provider = providers[providerId];
        Offer storage offer = provider.offers[offerId];

        if(offer.id == 0) {
            emit Message("There is no offer with this provider/offer ids");
            return;
        }

        if(offer.pickups[msg.sender].consumer != address(0)) {
            emit Message("Reservation already exists for this product");
            return;
        }

        if( offer.quantity < quantity ) {
            emit Message("Not enough units to sell");
            return;
        }

        //  Reserve quantity
        offer.quantity += quantity;

        if( offer.price * quantity != msg.value ) {
            emit Message("Invalid transfer value");
            return;
        }

        Reserve memory reserve = Reserve(msg.sender, quantity, msg.value, now + pickupTime);

        offer.pickups[msg.sender] = reserve;
    }


    function acceptPickup(address providerId, uint16 offerId) public {

        //  TODO: validate the existance of the provider and the offer...for now, assume they both exist
        Provider storage provider = providers[providerId];
        Offer storage offer = provider.offers[offerId];
        Reserve memory pickup = offer.pickups[msg.sender];

        //  TODO: Avoid reentrancy
        
        assert( pickup.consumer != address(0) );
        if(pickup.consumer == address(0)) {
            emit Message("Pickup does not exists for this consumer");
            return;
        }


        //  TODO: transfer may throw...need to deal with the exception
        provider.id.transfer(pickup.amount);

        //  TODO: if transfer throws, then re-insert the pickup into the map
        delete offer.pickups[msg.sender];

    }
  
}
