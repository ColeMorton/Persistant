'use strict'

angular.module 'persistantApp'
.service 'healthFactory', ($timeout) ->
  class Health

    RECHARGE_TIME = 2
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
      myMinuteTicker = $timeout(@minuteTicker, MINUTE)

    secondTicker: =>
      second += 1
      @updateHealthIncrementCountdown()
      @updateFitnessLoss()
      mySecondTicker = $timeout(@secondTicker, SECOND)

    minuteTicker: =>
      minute += 1
      myMinuteTicker = $timeout(@myMinuteTicker, MINUTE)

    updateHealthIncrementCountdown: =>
      if @isHealthFull()
        @model.nextHealthPointIn = 0
        return

      if @model.nextHealthPointIn > 0
        @model.nextHealthPointIn -= 1

      if !@isHealthFull() && @model.nextHealthPointIn == 0
        @incrementHealth()
        @model.nextHealthPointIn = @model.healthIncrementLength

    getHealthIncrementLength: =>
      totalRechargeTimeInSeconds = RECHARGE_TIME * MINUTE
      pointRechargeTimeInSeconds = totalRechargeTimeInSeconds / @model.fitness
      parseInt(pointRechargeTimeInSeconds / SECOND)

    incrementHealth: =>
      @model.totalHealthGained += 1
      @updateHealth()

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
      @save()

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

        @save()

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
      @save()

    save: =>
      @model.healthModifiedDate = moment()
      @model.save()
