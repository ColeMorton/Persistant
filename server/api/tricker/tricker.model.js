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
  hookSkill: Number,
  injuredDate: Date,
  maxFitness: Number
});

module.exports = mongoose.model('Tricker', TrickerSchema);
