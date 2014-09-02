'use strict'

angular.module 'persistantApp'
.controller 'TrickerCtrl', ($scope, $http, $timeout, trickerFactory) ->

  $http.get('/api/trickers').success (trickers) ->
    $scope.tricker = new trickerFactory trickers[0]
    console.log trickers

  $scope.longRun = ->
    $scope.tricker.action.run(100)

  $scope.mediumRun = ->
    $scope.tricker.action.run(50)

  $scope.shortRun = ->
    $scope.tricker.action.run(20)

  $scope.warmUp = ->
    $scope.tricker.action.warmUp()

  $scope.maxHook = ->
    $scope.tricker.action.hook(100)

  $scope.midHook = ->
    $scope.tricker.action.hook(50)

  $scope.minHook = ->
    $scope.tricker.action.hook(20)

  $scope.reset = ->
    $scope.tricker.model.reset()

  newTricker = ->
    tricker = {}
    tricker.totalEnergyGained = 50
    tricker.totalEnergyUsed = 0
    tricker.fitness = 100
    tricker.fitnessModifiedDate = moment()
    tricker.lastModified = moment()
    $http.post '/api/trickers', tricker

  $scope.$on 'destory', ->
    $scope.tricker = null
