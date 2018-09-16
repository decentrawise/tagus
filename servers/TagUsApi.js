const mongoose = require('mongoose');
const express = require('express');
const Offer = require('./models/Offer');
const config = require('./config.json');

// Connect to the mongodb database
mongoose.connect(config.database);

// Initialise API
const app = express();
app.use(express.json());

// Query endpoint
app.post('/query', function (req, res) {
  const data = req.body;


})

// Find offers nearby
Message.find({
  location: {
   $near: {
    $maxDistance: 1000,     // Distance in meters
    $geometry: {
     type: "Point",
     coordinates: [long, latt]
    }
   }
  }
 }).find((error, results) => {
  if (error) console.log(error);
  console.log(JSON.stringify(results, 0, 2));
 });
