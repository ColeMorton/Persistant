'use strict'

angular.module 'persistantApp'
.service 'healthierFactory', ($timeout) ->
  class Health

    RECHARGE_TIME = 4
    MINUTE = 60000
    SECOND = 1000
    FITNESS_ADDITION = 15
    FITNESS_REDUCTION = 5
    MIN_FITNESS = 80

    mySecondTicker = null
    myMinuteTicker = null
    second = 0
    minute = 0

    constructor: (tricker) ->
      @model = tricker
      @updateHealth()
      @model.healthIncrementLength = @getHealthIncrementLength()
      @model.nextHealthPointIn = @model.healthIncrementLength
      @addOfflineHealth()
      mySecondTicker = $timeout(@secondTicker, SECOND)
      myMinuteTicker = $timeout(@myMinuteTicker, MINUTE)

    secondTicker: =>
      second += 1
      @updateHealthIncrementCountdown()
      @updateFitnessLoss()
      mySecondTicker = $timeout(@secondTicker, SECOND)

    minuteTicker: =>
      minute += 1
      myMinuteTicker = $timeout(@myMinuteTicker, MINUTE)

    updateHealthIncrementCountdown: =>
      if (@isHealthFull())
        @model.nextHealthPointIn = 0
      else if (@model.nextHealthPointIn != 1)
        @model.nextHealthPointIn -= 1
      else if !@isHealthFull()
        @incrementHealth()
        @model.nextHealthPointIn = @model.healthIncrementLength

    getHealthIncrementLength: =>
      totalRechargeTimeInSeconds = RECHARGE_TIME * MINUTE
      pointRechargeTimeInSeconds = totalRechargeTimeInSeconds / @model.fitness
      parseInt(pointRechargeTimeInSeconds / SECOND)

    incrementHealth: =>
      @model.totalHealthGained += 1
      @updateHealth()
      @model.save()

    addFitness: (fitness) =>
      fitness = FITNESS_ADDITION if fitness > FITNESS_ADDITION
      @model.fitness += fitness

    addOfflineHealth: =>
      offlineTime = @getOfflineTime()
      if (@model.health + offlineTime > @model.fitness)
        @model.totalHealthGained = @model.totalHealthUsed + @model.fitness
      else
        @model.totalHealthGained += offlineTime
      @updateHealth
      @model.save()

    updateFitnessLoss: ->
      nextFitnessLoss = moment(@model.fitnessLossDate).add('hours', 1)
      if (moment().isAfter(nextFitnessLoss))
        @model.fitness -= @getFitnessReduction()
        @model.fitness = MIN_FITNESS if @model.fitness < MIN_FITNESS
        @model.fitnessLossDate = moment()

        if @model.health > @model.fitness
          healthReduction = @model.health - @model.fitness
          @model.totalHealthGained -= healthReduction
          @updateHealth()

        @model.save()

    updateHealth: =>
      @model.health = @model.totalHealthGained - @model.totalHealthUsed

    isHealthFull: =>
      @model.health >= @model.fitness

    getOfflineTime: =>
      duration = moment().diff(@model.lastModified) / SECOND
      parseInt(duration / @model.healthIncrementLength)

    getFitnessReduction: =>
      parseInt((FITNESS_REDUCTION / @model.fitness) * 100)

    canSpendHealth: (spend) =>
      @model.health >= spend

    spendHealth: (spend) =>
      throw new Error "Cannot spend health" if !@canSpendHealth spend
      @model.totalHealthUsed += spend
      @updateHealth()
      @model.save()
