'use strict'

angular.module 'persistantApp'
.controller 'ToysCtrl', ($scope, $http, socket, $timeout) ->
  $scope.tricker = {}
  $scope.isResting = false;

  $http.get('/api/rests/last').success (trickers) ->
    console.log trickers[0]
    $scope.tricker = trickers[0]
    refresh();

    if $scope.tricker.lastRested != null
      duration = getDuration $scope.tricker.lastRested
      recharge duration

      $scope.tricker.lastRested = null
      $http.put '/api/rests/' + $scope.tricker._id, $scope.tricker

  $scope.rest = ->
    $scope.tricker.lastRested = moment()
    $http.put '/api/rests/' + $scope.tricker._id, $scope.tricker
    $scope.isResting = true

  $scope.run = ->
    updateHealth $scope.tricker.health -= 10

  getDuration = (lastRested) ->
    result = moment().diff(lastRested) / 60000
    if result < 1
      return 0
    else
      return parseInt(result)

  recharge = (duration) ->
    # 7 hours = 420
    health = $scope.tricker.health
    health += duration / 45 * 100
    updateHealth health

  updateHealth = (health) ->
    health = 1 if health  < 1
    health = 100 if health > 100

    $scope.tricker.health = parseInt(health)
    $http.put '/api/rests/' + $scope.tricker._id, $scope.tricker

  refresh = ->
    recharge 1
    mytimeout = $timeout(refresh, 60000)

