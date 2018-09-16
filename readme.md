# TagUs Project

This project is work in progress... It is our entry for the QTUM Hackathon 2018.

### Why the name 'TagUs'

TagUs comes from Tagus (the river in Lisbon). Both developers of this project are from Lisbon and the Tagus river divides them since
each lives on opposite margins. So the development of this project involved lots os crossings of the Tagus river, and mainly by
internet conferences, since this is 21st century, but the river was there anyway playing it's part in the communication. So we decided
to give it a place in the project by naming it on it's behalf.

### Requirements

* QTUM Development Environment
* QTUM Node running
* QTUM `qcli` and `solar` available
* MondoDB for storing geo location data and Query
* Express API for serving queries
* React Native for the Mobile App

### The Problem

Most of the time the providers of some product or service have to rely on third-party services to share their works, get requests,
schedule deliveries or pickups and finally the payment processor or bank that all together cause extreme friction on this process
that should be easy to accomplish. The QTUM blockchain is ideal to implement this workflow and remove all this friction.

### The Solution

TagUs is a system to facilitate local trust-less business activities between neighbors or more distant people, preventing abuse or payment issues.
Also, it will allow in the future for the providers to get funding for their projects from the crowd, by selling futures over their productions...

### The Technology

The TagUs system brings together:
* QTUM Blockchain for immediate payment
* QTUM Smart Contracts for mediation and escrow
* Geo location on Blockchain through an Oracle export to MongoDB
* Interesting workflow that makes sure that everyone is incentivized to behave in the best way possible
* Guaranty that the product/service is received and the price paid or otherwise penalizations for the infringing part apply

### Workflow

#### Transaction
1. Publish - Provider publishes his offers to the platform:
    * Offer:
        * Location:
            * Latitude
            * Longitude
            * Address
            * Contact
        * Title
        * Foto
        * Description
        * Category
        * Units available
            * Quantity
            * Unit
        * Unit price
        * Availability - until when this offer is available
        * Pickup - Can this offer be picked up
        * Pickup reservation period
        * Delivery - Can this offer be delivered
        * Delivery distance
        * Delivery reservation period
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
