'use strict'

angular.module 'persistantApp'
.service 'healthFactory', ($timeout) ->
  class Health

    RECHARGE_TIME = 480
    WARMTH_DEGEN_TIME = 30
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
      @model.healthIncrementLength = @getHealthRegenTime()
      @model.nextHealthPointIn = @getHealthRegenTime()
      @loseOfflineWarmth()
      @addOfflineHealth()
      mySecondTicker = $timeout(@secondTicker, SECOND)
      myMinuteTicker = $timeout(@minuteTicker, MINUTE)

    secondTicker: =>
      second += 1
      # @updateWarmthCountdown()
      @updateHealthIncrementCountdown()
      @updateFitnessLoss()
      mySecondTicker = $timeout(@secondTicker, SECOND)

    minuteTicker: =>
      minute += 1
      myMinuteTicker = $timeout(@myMinuteTicker, MINUTE)

    updateWarmthCountdown: =>
      nextWarmthLoss = moment(@model.warmthLossDate).add('hours', 1)

    updateHealthIncrementCountdown: =>
      if @isHealthFull()
        @model.nextHealthPointIn = 0
        return

      if @model.nextHealthPointIn > 0
        @model.nextHealthPointIn -= 1

      if !@isHealthFull() && @model.nextHealthPointIn == 0
        @incrementHealth()
        @model.nextHealthPointIn = @getHealthRegenTime()

    incrementHealth: =>
      @model.totalHealthGained += 1
      @updateHealth()

    addFitness: (fitness) =>
      fitness = FITNESS_ADDITION if fitness > FITNESS_ADDITION
      @model.fitness += fitness

    addWarmth: (energyUsed) =>
      warmth =  (energyUsed / @model.fitness) * 100
      @model.warmth += parseInt warmth
      @model.warmth = 100 if @model.warmth > 100
      @saveWarmth()

    loseOfflineWarmth: =>
      offlineWarmthLoss = @getOfflineWarmth()
      if (@model.warmth > offlineWarmthLoss)
        @model.warmth -= offlineWarmthLoss
      else
        @model.warmth = 0
      @saveWarmth()

    addOfflineHealth: =>
      offlineHealth = @getOfflineHealth()
      if (@model.health + offlineHealth > @model.fitness)
        @model.totalHealthGained = @model.totalHealthUsed + @model.fitness
      else
        @model.totalHealthGained += offlineHealth

      @updateHealth
      @saveHealth()

    updateFitnessLoss: ->
      nextFitnessLoss = moment(@model.fitnessLossDate).add(1, 'hours')
      if (moment().isAfter(nextFitnessLoss))
        @model.fitness -= @getFitnessReduction()
        @model.fitness = MIN_FITNESS if @model.fitness < MIN_FITNESS
        @model.fitnessLossDate = moment()

        if @model.health > @model.fitness
          healthReduction = @model.health - @model.fitness
          @model.totalHealthGained -= healthReduction
          @updateHealth()

        @saveHealth()

    updateHealth: =>
      @model.health = @model.totalHealthGained - @model.totalHealthUsed

    isHealthFull: =>
      @model.health >= @model.fitness

    getOfflineHealth: =>
      duration = moment().diff(@model.healthModifiedDate) / SECOND
      parseInt(duration / @getHealthRegenTime())

    getOfflineWarmth: =>
      duration = moment().diff(@model.warmthModifiedDate) / SECOND
      parseInt(duration / @getWarmthDegenTime())

    getHealthRegenTime: =>
      totalInSeconds = RECHARGE_TIME * MINUTE
      pointInSeconds = totalInSeconds / @model.fitness
      parseInt(pointInSeconds / SECOND)

    getWarmthDegenTime: =>
      totalInSeconds = WARMTH_DEGEN_TIME * MINUTE
      pointInSeconds = totalInSeconds / 100
      parseInt(pointInSeconds / SECOND)

    getFitnessReduction: =>
      parseInt((FITNESS_REDUCTION / @model.fitness) * 100)

    canSpendHealth: (spend) =>
      @model.health >= spend

    spendHealth: (spend) =>
      throw new Error "Cannot spend health" if !@canSpendHealth spend
      @model.totalHealthUsed += spend
      @addWarmth(spend)
      @updateHealth()
      @saveHealth()

    saveHealth: =>
      @model.healthModifiedDate = moment()
      @model.save()

    saveWarmth: =>
      @model.warmthModifiedDate = moment()
      @model.save()
