'use strict';

var _ = require('lodash');
var Rest = require('./rest.model');

// Get list of rests
exports.index = function(req, res) {
  Rest.find(function (err, rests) {
    if(err) { return handleError(res, err); }
    return res.json(200, rests);
  });
};

// Get a single rest
exports.show = function(req, res) {
  Rest.findById(req.params.id, function (err, rest) {
    if(err) { return handleError(res, err); }
    if(!rest) { return res.send(404); }
    return res.json(rest);
  });
};

// Get a single rest
exports.last = function(req, res) {
  Rest.find().sort({$natural:-1}).limit(1).exec(function (err, rests) {
    if(err) { return handleError(res, err); }
    return res.json(200, rests);
  });
};

// Creates a new rest in the DB.
exports.create = function(req, res) {
  Rest.create(req.body, function(err, rest) {
    if(err) { return handleError(res, err); }
    return res.json(201, rest);
  });
};

// Updates an existing rest in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Rest.findById(req.params.id, function (err, rest) {
    if (err) { return handleError(res, err); }
    if(!rest) { return res.send(404); }
    var updated = _.merge(rest, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, rest);
    });
  });
};

// Deletes a rest from the DB.
exports.destroy = function(req, res) {
  Rest.findById(req.params.id, function (err, rest) {
    if(err) { return handleError(res, err); }
    if(!rest) { return res.send(404); }
    rest.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}
