'use strict'

angular.module 'persistantApp'
.service 'healthFactory', ($timeout) ->
  class Health

    RECHARGE_TIME = 480
    ENERGY_REGEN_TIME = 480
    WARMTH_DEGEN_TIME = 30
    FITNESS_DEGEN_TIME = 14400
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

      @loseOfflineWarmth()
      @addOfflineHealth()

      @secondTicker()
      myMinuteTicker = $timeout(@minuteTicker, MINUTE)

    secondTicker: =>
      second += 1
      @updateWarmthDegen moment()
      @updateHealthRegen moment()
      @updateFitnessDegen moment()
      mySecondTicker = $timeout(@secondTicker, SECOND)

    minuteTicker: =>
      minute += 1
      myMinuteTicker = $timeout(@myMinuteTicker, MINUTE)

    updateWarmthDegen: (endDate) ->
      nextPoint = moment(@model.warmthModifiedDate).add(@getWarmthDegenTime(), 'seconds')
      if (endDate.isAfter(nextPoint))
        @model.warmth -= 1
        @model.warmth = 0 if @model.warmth < 0
        @model.warmthModifiedDate = moment()
        @model.save()

      else
        @model.nextWarmthPointIn = parseInt(Math.abs(moment().diff(nextPoint) / 1000))

    updateHealthRegen: (endDate) =>
      nextPoint = moment(@model.healthModifiedDate).add(@getHealthRegenTime(), 'seconds')
      if (endDate.isAfter(nextPoint))
        @model.totalHealthGained += 1
        @model.healthModifiedDate = moment()

        if @model.health > @model.fitness
          healthReduction = @model.health - @model.fitness
          @model.totalHealthGained -= healthReduction

        @updateHealth()
        @model.save()

      else
        @model.nextHealthPointIn = parseInt(Math.abs(moment().diff(nextPoint) / 1000))

    updateFitnessDegen: (endDate) ->
      nextPoint = moment(@model.fitnessLossDate).add(@getFitnessDegenTime(), 'seconds')
      if (endDate.isAfter(nextPoint))
        @model.fitness -= 1
        @model.fitness = MIN_FITNESS if @model.fitness < MIN_FITNESS
        @model.fitnessLossDate = moment()

        if @model.health > @model.fitness
          healthReduction = @model.health - @model.fitness
          @model.totalHealthGained -= healthReduction
          @updateHealth()

        @model.save()

      else
        @model.nextFitnessPointIn = parseInt(Math.abs(moment().diff(nextPoint) / 1000))

    addFitness: (fitness) =>
      fitness = FITNESS_ADDITION if fitness > FITNESS_ADDITION
      @model.fitness += fitness

    addWarmth: (energyUsed) =>
      warmth =  (energyUsed / @model.fitness) * 100
      @model.warmth += parseInt warmth
      @model.warmth = 100 if @model.warmth > 100
      @model.save()

    loseOfflineWarmth: =>
      offlineWarmthLoss = @getOfflineWarmth()
      if (@model.warmth > offlineWarmthLoss)
        @model.warmth -= offlineWarmthLoss
      else
        @model.warmth = 0
      @model.save()

    addOfflineHealth: =>
      offlineHealth = @getOfflineHealth()
      if (@model.health + offlineHealth > @model.fitness)
        @model.totalHealthGained = @model.totalHealthUsed + @model.fitness
      else
        @model.totalHealthGained += offlineHealth

      @updateHealth
      @model.save()

    getOfflineHealth: =>
      duration = moment().diff(@model.healthModifiedDate) / SECOND
      parseInt(duration / @getHealthRegenTime())

    getOfflineWarmth: =>
      duration = moment().diff(@model.warmthModifiedDate) / SECOND
      parseInt(duration / @getWarmthDegenTime())

    getHealthRegenTime: =>
      pointInMinutes = ENERGY_REGEN_TIME / @model.fitness
      pointInSeconds = pointInMinutes * 60
      parseInt(pointInSeconds)

    getWarmthDegenTime: =>
      totalInSeconds = WARMTH_DEGEN_TIME * MINUTE
      pointInSeconds = totalInSeconds / 100
      parseInt(pointInSeconds / SECOND)

    getFitnessDegenTime: =>
      totalInSeconds = FITNESS_DEGEN_TIME * MINUTE
      pointInSeconds = totalInSeconds / 100
      parseInt(pointInSeconds / SECOND)

    updateHealth: =>
      @model.health = @model.totalHealthGained - @model.totalHealthUsed

    canSpendHealth: (spend) =>
      @model.health >= spend

    spendHealth: (spend) =>
      throw new Error "Cannot spend health" if !@canSpendHealth spend
      @model.totalHealthUsed += spend
      @addWarmth(spend)
      @updateHealth()
      @model.save()

    isHealthFull: =>
      @model.health >= @model.fitness

    isWarmthEmpty: =>
      @model.warmth <= 0

    isFitnessEmpty: =>
      @model.fitness <= 80
