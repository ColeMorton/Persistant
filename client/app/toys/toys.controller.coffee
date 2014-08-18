'use strict'

angular.module 'persistantApp'
.controller 'ToysCtrl', ($scope, $http, socket, $timeout) ->
  $scope.tricker = {}
  $scope.isResting = false
  $scope.health = 0
  $scope.nextHealthPointIn = 0
  seconds = 0
  minutes = 0

  RECHARGE_TIME = 30
  MINUTE = 60000

  $scope.run = ->
    return if getHealth() < 11
    $scope.tricker.totalHealthUsed += 10
    updateTricker()

  getHealth = ->
    return $scope.tricker.totalHealthGained - $scope.tricker.totalHealthUsed

  isHealthFull = ->
    getHealth() == $scope.tricker.fitness

  healthIncrementLength = ->
    return (RECHARGE_TIME * MINUTE) / $scope.tricker.fitness

  refresh = ->
    updateNextHealthPointIn()
    $timeout(refresh, healthIncrementLength())
    return if isHealthFull()

    $scope.tricker.totalHealthGained += 1
    $scope.tricker.lastRested = moment()
    updateTricker()

  getOfflineHealth = ->
    duration = moment().diff($scope.tricker.lastRested)
    return parseInt(duration / healthIncrementLength())

  updateNextHealthPointIn = ->
    if isHealthFull()
      $scope.nextHealthPointIn = 0
    else
      $scope.nextHealthPointIn = parseInt((healthIncrementLength() / 1000) + 1)

  updateFitnessLoss = ->
    nextFitnessLoss = moment($scope.tricker.fitnessLossDate).add('days', 1)
    if (moment().isAfter(nextFitnessLoss))
      console.log "Drop fitness"

      if $scope.tricker.fitness >= 52
        $scope.tricker.fitness -= 2
      else if $scope.tricker.fitness >= 51
        $scope.tricker.fitness -= 1

      $scope.tricker.fitnessLossDate = moment()

  addOfftimeTime = ->
    duration = moment().diff($scope.tricker.lastRested)
    if (getHealth() + getOfflineHealth() > $scope.tricker.fitness)
      $scope.tricker.totalHealthGained = $scope.tricker.totalHealthUsed + $scope.tricker.fitness
    else
      $scope.tricker.totalHealthGained += getOfflineHealth()

    updateTricker()

  updateTricker = ->
    $scope.health = getHealth()
    $scope.tricker.lastRested = moment()
    $http.put '/api/rests/' + $scope.tricker._id, $scope.tricker

  minuteTicker = ->
    minutes += 1
    updateFitnessLoss()
    myMinuteTicker = $timeout(minuteTicker, MINUTE)

  secondTicker = ->
    seconds += 1
    $scope.nextHealthPointIn -= 1
    $scope.nextHealthPointIn = 0 if $scope.nextHealthPointIn < 0
    mySecondTicker = $timeout(secondTicker, MINUTE / 60)
    console.log seconds

  reset = ->
    $http.get('/api/rests/last').success (trickers) ->
      console.log trickers[0]
      $scope.tricker = trickers[0]
      $scope.tricker.lastRested = moment()
      $scope.tricker.totalHealthGained = 0
      $scope.tricker.totalHealthUsed = 0
      $scope.tricker.fitness = 100
      $scope.tricker.fitnessLossDate = moment()
      $http.put '/api/rests/' + $scope.tricker._id, $scope.tricker

  start = ->
    $http.get('/api/rests/last').success (trickers) ->
      console.log trickers[0]
      $scope.tricker = trickers[0]

      addOfftimeTime();

      $scope.health = getHealth()
      $scope.healthPointRefreshTime = parseInt(healthIncrementLength() / 1000)
      updateNextHealthPointIn()

      $timeout(refresh, healthIncrementLength())
      $timeout(minuteTicker, MINUTE)
      $timeout(secondTicker, MINUTE / 60)

  # reset()
  start()
