'use strict'

angular.module 'persistantApp'
.controller 'TrickerCtrl', ($scope, $http, $timeout, trickerFactory) ->

  mySecondTicker = null

  $http.get('/api/rests/last').success (trickers) ->
    $scope.tricker = new trickerFactory trickers[0]
    console.log $scope.tricker

  $scope.$on '$destroy', ->
    $timeout.cancel mySecondTicker
