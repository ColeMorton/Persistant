'use strict'

angular.module 'persistantApp'
.controller 'TrickerCtrl', ($scope, $http, $timeout, trickerFactory) ->

  $http.get('/api/rests/last').success (trickers) ->
    $scope.tricker = new trickerFactory trickers[0]
    console.log $scope.tricker

  $scope.run = ->
    $scope.tricker.action.run()

  $scope.reset = ->
    $scope.tricker.model.reset()
