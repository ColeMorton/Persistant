'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var TrickerSchema = new Schema({
  name: String,
  lastModified: Date,
  fitness: Number,
  fitnessLossDate: Date,
  age: Number,
  totalHealthGained: Number,
  totalHealthUsed: Number,
  healthModifiedDate: Date,
  active: Boolean
});

module.exports = mongoose.model('Tricker', TrickerSchema);
