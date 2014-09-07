'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var TrickerSchema = new Schema({
  name: String,
  lastModified: Date,
  fitness: Number,
  fitnessModifiedDate: Date,
  age: Number,
  totalEnergyGained: Number,
  totalEnergyUsed: Number,
  energyModifiedDate: Date,
  warmth: Number,
  warmthModifiedDate: Date,
  active: Boolean,
  skillHK: Number,
  styleHK: Number,
  beltHK: Number,
  skillC1: Number,
  styleC1: Number,
  beltC1: Number,
  injuredDate: Date,
  maxFitness: Number
});

module.exports = mongoose.model('Tricker', TrickerSchema);
