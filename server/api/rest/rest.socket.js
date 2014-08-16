/**
 * Broadcast updates to client when the model changes
 */

'use strict';

var Rest = require('./rest.model');

exports.register = function(socket) {
  Rest.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  Rest.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('rest:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('rest:remove', doc);
}