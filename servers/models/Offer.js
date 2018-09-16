var mongoose = require("mongoose");
var Schema = mongoose.Schema;

var OfferSchema = new Schema(
  {
    providerAddr: String,
    providerName: String,

    title: String,
    category: String,
    expirationBlock: Number,

    location: {
      type: { type: String },
      coordinates: []
    }
  },
  {
    timestamps: true
  }
);

OfferSchema.index({ location: "2dsphere" });

var Offer = mongoose.model("Offer", OfferSchema);

module.exports = Offer;
