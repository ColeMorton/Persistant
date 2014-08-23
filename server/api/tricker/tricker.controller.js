'use strict';

var _ = require('lodash');
var Tricker = require('./tricker.model');

// Get list of trickers
exports.index = function(req, res) {
  Tricker.find(function (err, trickers) {
    if(err) { return handleError(res, err); }
    return res.json(200, trickers);
  });
};

// Get a single tricker
exports.show = function(req, res) {
  Tricker.findById(req.params.id, function (err, tricker) {
    if(err) { return handleError(res, err); }
    if(!tricker) { return res.send(404); }
    return res.json(tricker);
  });
};

// Get a single rest
exports.last = function(req, res) {
  Tricker.find().sort({$natural:-1}).limit(1).exec(function (err, trickers) {
    if(err) { return handleError(res, err); }
    return res.json(200, trickers);
  });
};

// Creates a new tricker in the DB.
exports.create = function(req, res) {
  Tricker.create(req.body, function(err, tricker) {
    if(err) { return handleError(res, err); }
    return res.json(201, tricker);
  });
};

// Updates an existing tricker in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Tricker.findById(req.params.id, function (err, tricker) {
    if (err) { return handleError(res, err); }
    if(!tricker) { return res.send(404); }
    var updated = _.merge(tricker, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, tricker);
    });
  });
};

// Deletes a tricker from the DB.
exports.destroy = function(req, res) {
  Tricker.findById(req.params.id, function (err, tricker) {
    if(err) { return handleError(res, err); }
    if(!tricker) { return res.send(404); }
    tricker.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
