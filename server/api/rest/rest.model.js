'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var RestSchema = new Schema({
  name: String,
  lastRested: Date,
  health: Number,
  fitness: Number,
  age: Number,
  totalHealthGained: Number,
  totalHealthUsed: Number,
  active: Boolean
});

module.exports = mongoose.model('Rest', RestSchema);
