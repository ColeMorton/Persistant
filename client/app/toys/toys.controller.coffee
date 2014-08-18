'use strict'

angular.module 'persistantApp'
.controller 'ToysCtrl', ($scope, $http, socket, $timeout) ->
  $scope.tricker = {}
  $scope.isResting = false
  $scope.health = 0
  $scope.nextHealthPointIn = 0
  $scope.runSpend = 20
  seconds = 0
  minutes = 0

  RECHARGE_TIME = 30
  MINUTE = 60000
  FITNESS_ADDITION = 15
  FITNESS_REDUCTION = 5
  MIN_FITNESS = 80

  $scope.run = ->
    return if getHealth() < 10
    $scope.tricker.totalHealthUsed += getRunSpenditure()
    $scope.tricker.fitness += getFitnessAddition()
    updatePage()
    updateTricker()
    console.log "Additional fitness: " + getFitnessAddition()

  start = ->
    $http.get('/api/rests/last').success (trickers) ->
      console.log trickers[0]
      $scope.tricker = trickers[0]

      updateFitnessLoss()
      addOfftimeTime()

      updatePage()
      $scope.healthPointRefreshTime = parseInt(healthIncrementLength() / 1000)
      updateNextHealthPointIn()

      $timeout(incrementHealth, healthIncrementLength())
      $timeout(minuteTicker, MINUTE)
      $timeout(secondTicker, MINUTE / 60)

  reset = ->
    $http.get('/api/rests/last').success (trickers) ->
      console.log trickers[0]
      $scope.tricker = trickers[0]
      $scope.tricker.totalHealthGained = 50
      $scope.tricker.totalHealthUsed = 0
      $scope.tricker.fitness = 100
      $scope.tricker.fitnessLossDate = moment()
      updatePage()
      updateTricker()

  minuteTicker = ->
    minutes += 1
    updateFitnessLoss()
    myMinuteTicker = $timeout(minuteTicker, MINUTE)

  secondTicker = ->
    seconds += 1
    $scope.nextHealthPointIn -= 1
    $scope.nextHealthPointIn = 0 if $scope.nextHealthPointIn < 0
    mySecondTicker = $timeout(secondTicker, MINUTE / 60)
    # console.log seconds

  isHealthFull = ->
    getHealth() == $scope.tricker.fitness

  healthIncrementLength = ->
    return (RECHARGE_TIME * MINUTE) / $scope.tricker.fitness

  incrementHealth = ->
    updateNextHealthPointIn()
    $timeout(incrementHealth, healthIncrementLength())
    return if isHealthFull()

    $scope.tricker.totalHealthGained += 1
    updatePage()
    updateTricker()

  updateNextHealthPointIn = ->
    if isHealthFull()
      $scope.nextHealthPointIn = 0
    else
      $scope.nextHealthPointIn = parseInt((healthIncrementLength() / 1000) + 1)

  updateFitnessLoss = ->
    nextFitnessLoss = moment($scope.tricker.fitnessLossDate).add('minutes', 1)
    if (moment().isAfter(nextFitnessLoss))
      $scope.tricker.fitness -= getFitnessReduction()
      $scope.tricker.fitness = MIN_FITNESS if $scope.tricker.fitness < MIN_FITNESS
      $scope.tricker.fitnessLossDate = moment()

      if getHealth() > $scope.tricker.fitness
        healthReduction = getHealth() - $scope.tricker.fitness
        $scope.tricker.totalHealthGained -= healthReduction
        updatePage()

      updateTricker()

  addOfftimeTime = ->
    if (getHealth() + getOfflineHealth() > $scope.tricker.fitness)
      $scope.tricker.totalHealthGained = $scope.tricker.totalHealthUsed + $scope.tricker.fitness
    else
      $scope.tricker.totalHealthGained += getOfflineHealth()

    updateTricker()

  updateTricker = ->
    $scope.tricker.lastModified = moment()
    $http.put '/api/rests/' + $scope.tricker._id, $scope.tricker

  updatePage = ->
    $scope.health = getHealth()

  getOfflineHealth = ->
    duration = moment().diff($scope.tricker.lastModified)
    return parseInt(duration / healthIncrementLength())

  getHealth = ->
    return $scope.tricker.totalHealthGained - $scope.tricker.totalHealthUsed

  getFitnessAddition = ->
    spend = $scope.runSpend / 6
    result = parseInt((spend / 100) * $scope.tricker.fitness)
    result = FITNESS_ADDITION if result > FITNESS_ADDITION
    return result

  getFitnessReduction = ->
    return parseInt((FITNESS_REDUCTION / $scope.tricker.fitness) * 100)

  getRunSpenditure = ->
    $scope.runSpend = parseInt($scope.runSpend)
    return parseInt(($scope.runSpend / 100) * getHealth())

  # reset()
  start()
