'use strict'

angular.module 'persistantApp'
.controller 'TrickerCtrl', ($scope, $http, $timeout, trickerFactory) ->

  $http.get('/api/trickers').success (trickers) ->
    $scope.tricker = new trickerFactory trickers[0]
    console.log trickers[0]

  $scope.longRun = ->
    $scope.tricker.action.run(90)

  $scope.mediumRun = ->
    $scope.tricker.action.run(40)

  $scope.shortRun = ->
    $scope.tricker.action.run(20)

  $scope.warmUp = ->
    $scope.tricker.action.warmUp()

  $scope.reset = ->
    $scope.tricker.model.reset()

  newTricker = ->
    tricker = {}
    tricker.totalHealthGained = 50
    tricker.totalHealthUsed = 0
    tricker.fitness = 100
    tricker.fitnessLossDate = moment()
    tricker.lastModified = moment()
    $http.post '/api/trickers', tricker
