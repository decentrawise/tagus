pragma solidity ^0.4.19;

contract TagUsTransaction {

  struct Provider {
    string name;
    string streetAddress;
    string contact;
    uint32 latitude;
    uint32 longitude;
  }

  struct Product {
    string title;       //  A title/name for the product
    string category;    //  Category which this product belongs
    string description; //  Text description of the product
    string photoURL;    //  URL for a photo description of the product
    uint period;        //  Period which this product will be available
  }

  struct Supply {
    uint quantity;
    string unit;
  }

  struct Fees {
    uint cancellation;
    uint publishing;
  }

  struct Delivery {
    bool available;
    uint distance;
    string distanceUnits;   //  Units for the distance (Kilometers, Meters, Miles, etc)
  }

  struct Pickup {
    bool available;
    uint period;            //  Period that the pickup wait will stand
  }

  struct Offer {
    uint256 id;         //  Hash for this offer

    Provider provider;  //  Location and contact details
    Product product;    //  Product details

    Supply supply;
    Fees fees;
    Delivery delivery;
    Pickup pickup;

  }


  uint256 lastId = 0;
  mapping (uint256 => Offer) offers;


  function postProduct(string title, string description, uint quantity) public {
    lastId++;
    Offer memory offer = Offer( lastId,
                                Provider( "<name>", "<address>", "<phone number or email>", 0, 0 ),        //  Provider details
                                Product( title, "<category>", description, "http://someimage.png", 60 ),   //  Product details
                                Supply(quantity, "km"),
                                Fees(10, 10),
                                Delivery(true, 10, "km"),
                                Pickup(true, 60)
                              );

    offers[lastId] = offer;

  }

}
