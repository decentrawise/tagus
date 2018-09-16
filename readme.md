# TagUs Project

This project is work in progress... It is our entry for the QTUM Hackathon 2018.

### Why the name 'TagUs'

TagUs comes from Tagus (the river in Lisbon). Both developers of this project are from Lisbon and the Tagus river divides them since
each lives on opposite margins. So the development of this project involved lots of crossings of the Tagus river (mainly by
internet conferences, since we're in the 21st century already), but the river was there anyway playing it's part in the communication. So we decided
to give it a place in the project by naming it on it's behalf.

### Requirements

* QTUM Development Environment
* QTUM Node running
* QTUM `qcli` and `solar` available
* MondoDB for storing geo location data and Query
* Express API for serving queries
* React Native for the Mobile App

### The Problem

Most of the times, product or service providers need to rely on third-party services (suppliers, transports, orders, etc) to have their job done. In the end, the client needs to be satisfied, but also the provider needs to be happy. 
A lot can happen along this line, like misunderstandings, payment delays and sometimes, even no payments at all.
QTum blockchain is a great platform to bring some agility and peace of mind to this workflow.

### The Solution

TagUs makes your life a lot easier by making sure your business and your relations go smoothly, preventing abusive commercial relations and payment issues.
In the future, we want to enable funding for providers, so they can develop their projects, selling futures over their products.

### What TagUs offers

* Smart-contracts that guarantee smooth trading of products and services to everybody from the provider to the consumer
* Exposure to the providers by displaying them on searches
* Search engine connects local providers to local consumers
* Search and notification facilities for everyone who wants to know about a service or product
* Allow to make product or service reservations (secure the product until I get there or order it home)
* Allow consumers to invest on new future product developments in the area

### The Technology

The TagUs system brings together:
* QTUM Blockchain for immediate payment
* QTUM Smart Contracts for mediation and escrow
* Geo location on Blockchain through an Oracle export to MongoDB
* Interesting workflow that makes sure that everyone is incentivized to behave in the best way possible
* Guaranty that the product/service is traded at the arranged price, otherwise compensations are taken from the infringing party

### Workflow

#### Transaction
1. Create Provider Profile - Fill in some details from you as a product supplier:
    * profile:
        * Name
        * Address
        * Contact
        * Location (latitude and longitude)
        * Delivery (if can deliver, the distance and delivery period)

1. Publish - Provider publishes his offers to the platform:
    * Offer:
        * Title
        * Description
        * Category
        * Foto
        * Units available
            * Quantity
            * Unit
        * Unit price
        * Availability - until when this offer is available
        * Publishing fee - there is a minimum defined by us and the provider can agree to pay more to appear higher in the lists
        * Cancellation fee - between 10% and 50%
2. Discovery:
    * Search - Consumer searches for available products/services by:
        * Keywords in title
        * Category
        * Location
    * Watch - Consumer gets notifications about selected products/services when available by:
        * Keywords in title
        * Category
        * Location
3. Purchase:
    * Instant - Consumer goes directly to provider to purchase:
        * Provider post is deducted of the purchased units
        * Consumer pays in the app for purchased amount to provider
        * Provider receives a notification of payment issued
        * Provider receives a notification of payment confirmation
    * Scheduled - Consumer schedules pickup or delivery
        * Provider post is deducted of purchased units marked reserved. The reservation is valid for X days
        * Consumer selects pickup or delivery and pays in the app for purchased amount and delivery (optional) to the contract
        * At the time of pickup or delivery, the consumer has to check-in with a QR code provided by the provider, thus enabling the accept and reject operations. This check-in operation is only available during a reservation validity.
        * Accept - The product is picked-up and the consumer accepts the product. The amount that is standing in the contract is transferred to the provider and the transaction is completed
        * Rejected - The product is not satisfying, so the consumer rejects it without paying any fee
        * Expiry - After the reservation period expires:
            * Pickup - The provider or the consumer can cancel it and the provider keeps the cancellation fee for no pickup
            * Delivery - The consumer or the provider can cancel it and the consumer keeps the cancellation fee for no delivery
        * Cancelled - During the reservation period, any of the parties can cancel the purchase, but a cancellation fee is paid to the other party.

#### Futures

[TBD]

### Use cases

Samantha is growing blackberries and is picked 15Kg today. She opens TagUs on the phone and announces that she has 15Kg of blackberries available to sell at a price. The phone gathers geo-location and account information and sends to the blockchain.

George is looking for blackberries for a desert and needs 1Kg. He opens TagUs on the phone and searches for blackberries in a 5Km radius. Samantha pops up and George checks the price. He thinks it’s a good deal and makes a reservation for 1Kg of Samantha’s blackberries. After a couple of hours, he reaches Samantha’s selling spot and concludes the transaction.

------------

Margarida makes artistic birthday cakes, so she opens TagUs on her phone and instructs that to the application. Also that it should be ordered 2 days in advance and the price. Patricia wants to celebrate her child’s birthday, so she looks in TagUs and finds that Margarida supplies cakes in her area. Patricia orders a cake several days in advance. At the day Patricia picks it up, the transaction is complete and the cake is automatically payed.

------------

Samantha wants to change her product from blackberries to strawberries, but doesn’t know how the market will accept it and she needs investment to make this change. She opens TagUs and specify her intentions to grow 100Kg of strawberries next year and waits for investors.

Nathan has a local market in town and knows that strawberries are a good selling product, but scarce and pricy. He wants to do a good deal, so he opens TagUs and is happy to see that nearby, Samantha is willing to grow strawberries next year and since she’s getting investment for it, she’s willing to make reserves at a lower price. Nathan reserves 50Kg of strawberries for next year.
