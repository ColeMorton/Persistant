'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var RestSchema = new Schema({
  name: String,
  lastModified: Date,
  health: Number,
  fitness: Number,
  fitnessLossDate: Date,
  age: Number,
  totalHealthGained: Number,
  totalHealthUsed: Number,
  active: Boolean
});

module.exports = mongoose.model('Rest', RestSchema);
