const mongoose = require('mongoose');
const Qtum = require('qtumjs').Qtum;
const Offer = require('./models/Offer');
const config = require('../config.json');

// Connect to the mongodb database
mongoose.connect(config.database);

// Initialise QTUM blockchain connection
const repoData = require("../solar.development.json");
const qtum = new Qtum("http://qtum:test@localhost:3889", repoData);

// Load contract information
const contract = qtum.contract("../contracts/TagUsTransaction.sol");

// Listen to events of type OfferPublished
contract.onLog((entry) => {
  const event = entry.event;

  console.log('received:', entry.event);

  if (event.type === 'OfferPublished') {

    const offer = new Offer({
      providerAddr: event.providerAddr,
      providerName: event.providerName,

      title: event.title,
      category: event.category,
      expirationBlock: event.expirationBlock,

      location: {
        type: 'Point',
        coordinates: [
          event.longitude,
          event.latitude
        ]
      }
    });
    offer.save((err, message) => {
      if (err) console.error(err);
      if (message) console.log(message);
    })

  }
}, { minconf: 1 });
