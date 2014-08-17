'use strict'

angular.module 'persistantApp'
.controller 'ToysCtrl', ($scope, $http, socket, $timeout) ->
  $scope.tricker = {}
  $scope.isResting = false
  $scope.health = 0
  $scope.nextHealthPointIn = 0
  seconds = 0

  RECHARGE_TIME = 5
  MINUTE = 60000

  $scope.run = ->
    return if getHealth() < 11
    $scope.tricker.totalHealthUsed += 10
    updateTricker()

  getHealth = ->
    return $scope.tricker.totalHealthGained - $scope.tricker.totalHealthUsed

  healthIncrementLength = ->
    return (RECHARGE_TIME * MINUTE) / 100

  refresh = ->
    updateNextHealthPointIn()
    return if getHealth() + 1 > 100

    $scope.tricker.totalHealthGained += 1
    $scope.tricker.lastRested = moment()
    updateTricker()
    $timeout(refresh, healthIncrementLength())

  getOfflineHealth = ->
    duration = moment().diff($scope.tricker.lastRested)
    return parseInt(duration / healthIncrementLength())

  updateNextHealthPointIn = ->
    $scope.nextHealthPointIn = (healthIncrementLength() / 1000) + 1

  addOfftimeTime = ->
    duration = moment().diff($scope.tricker.lastRested)
    if (getHealth() + getOfflineHealth() > 100)
      increase = $scope.tricker.totalHealthGained - 100
      $scope.tricker.totalHealthGained += increase
    else
      $scope.tricker.totalHealthGained += getOfflineHealth()

    updateTricker()

  updateTricker = ->
    $scope.health = getHealth()
    $scope.tricker.lastRested = moment()
    $http.put '/api/rests/' + $scope.tricker._id, $scope.tricker

  ticker = ->
    seconds += 1
    $scope.nextHealthPointIn -= 1
    $scope.nextHealthPointIn = 0 if $scope.nextHealthPointIn < 0
    myTicker = $timeout(ticker, MINUTE / 60)

  reset = ->
    $http.get('/api/rests/last').success (trickers) ->
      console.log trickers[0]
      $scope.tricker = trickers[0]
      $scope.tricker.lastRested = moment()
      $scope.tricker.totalHealthGained = 0
      $scope.tricker.totalHealthUsed = 0
      $http.put '/api/rests/' + $scope.tricker._id, $scope.tricker

  # reset()

  $http.get('/api/rests/last').success (trickers) ->
    console.log trickers[0]
    $scope.tricker = trickers[0]

    addOfftimeTime();

    $scope.health = getHealth()
    $scope.healthPointRefreshTime = healthIncrementLength() / 1000
    updateNextHealthPointIn()

    $timeout(refresh, healthIncrementLength())
    $timeout(ticker, MINUTE / 60)
