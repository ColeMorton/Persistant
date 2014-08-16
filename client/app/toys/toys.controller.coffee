'use strict'

angular.module 'persistantApp'
.controller 'ToysCtrl', ($scope, $http, socket) ->
  $scope.rest = {}

  $http.get('/api/rests/last').success (rest) ->
    $scope.rest = rest[0]
    # socket.syncUpdates 'rest', $scope.rests

  $scope.startResting = ->
    $http.post '/api/rests',
      name: moment()
      info: moment().format('MMMM Do YYYY, h:mm:ss a')

  $scope.deleteRest = (rest) ->
    $http.delete '/api/rests/' + rest._id

  # $scope.$on '$destroy', ->
  #   socket.unsyncUpdates 'rest'
