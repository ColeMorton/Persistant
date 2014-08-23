/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var Tricker = require('./tricker.model');

exports.register = function(socket) {
  Tricker.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  Tricker.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('tricker:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('tricker:remove', doc);
}