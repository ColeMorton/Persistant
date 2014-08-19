'use strict'

angular.module 'persistantApp'
.controller 'TrickerCtrl', ($scope, $http, $timeout, trickerFactory) ->

  mySecondTicker = null

  $http.get('/api/rests/last').success (trickers) ->
    $scope.tricker = new trickerFactory trickers[0]
    console.log $scope.tricker
    secondTicker()

  secondTicker = ->
    console.log $scope.tricker.model.second
    mySecondTicker = $timeout(secondTicker, 1000)

  $scope.$on '$destroy', ->
    $timeout.cancel mySecondTicker
