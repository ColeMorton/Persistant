'use strict'

angular.module 'persistantApp'
.controller 'ToysCtrl', ($scope, $http, socket, $timeout, trickerFactory, healthFactory) ->
  tricker = trickerFactory
  health = healthFactory
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
    return if health.getHealth() < 10
    $scope.tricker.totalHealthUsed += getRunSpenditure()
    $scope.tricker.fitness += getFitnessAddition()
    updatePage()
    updateTricker()
    # console.log "Additional fitness: " + getFitnessAddition()

  healthUpdate = (health) ->
    # console.log "healthUpdate: " + health
    $scope.health = health

  nextHealthPointInUpdate = (time) ->
    # console.log time
    $scope.nextHealthPointIn = time

  start = ->
    $http.get('/api/rests/last').success (trickers) ->
      console.log trickers[0]
      $scope.tricker = trickers[0]
      tricker.init()
      health.init($scope.tricker, healthUpdate, nextHealthPointInUpdate)
      updateFitnessLoss()
      updatePage()
      $scope.healthPointRefreshTime = health.getHealthPointRefreshTime()
      $timeout(minuteTicker, MINUTE)
      $timeout(secondTicker, MINUTE / 60)

  reset = ->
    $http.get('/api/rests/last').success (trickers) ->
      console.log trickers[0]
      $scope.tricker = trickers[0]
      tricker.init()
      health.init($scope.tricker, healthUpdate, nextHealthPointInUpdate)
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

  updateFitnessLoss = ->
    nextFitnessLoss = moment($scope.tricker.fitnessLossDate).add('hours', 1)
    if (moment().isAfter(nextFitnessLoss))
      $scope.tricker.fitness -= getFitnessReduction()
      $scope.tricker.fitness = MIN_FITNESS if $scope.tricker.fitness < MIN_FITNESS
      $scope.tricker.fitnessLossDate = moment()

      if health.getHealth() > $scope.tricker.fitness
        healthReduction = health.getHealth() - $scope.tricker.fitness
        $scope.tricker.totalHealthGained -= healthReduction
        updatePage()

    updateTricker()

  updateTricker = ->
    $scope.tricker.lastModified = moment()
    $http.put '/api/rests/' + $scope.tricker._id, $scope.tricker

  updatePage = ->
    $scope.health = health.getHealth()

  getFitnessAddition = ->
    spend = $scope.runSpend / 6
    result = parseInt((spend / 100) * $scope.tricker.fitness)
    result = FITNESS_ADDITION if result > FITNESS_ADDITION
    return result

  getFitnessReduction = ->
    return parseInt((FITNESS_REDUCTION / $scope.tricker.fitness) * 100)

  getRunSpenditure = ->
    $scope.runSpend = parseInt($scope.runSpend)
    return parseInt(($scope.runSpend / 100) * health.getHealth())

  # reset()
  start()
