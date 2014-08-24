'use strict'

angular.module 'persistantApp'
.service 'healthFactory', ($timeout) ->
  class Health

    ENERGY_REGEN_TIME = 480
    MINUTE = 60000
    SECOND = 1000

    mySecondTicker = null

    constructor: (tricker) ->
      @model = tricker
      @model.healthIncrementLength = @getHealthRegenTime()
      @addOfflineHealth()
      @secondTicker()

    secondTicker: =>
      @updateHealthRegen()
      mySecondTicker = $timeout(@secondTicker, SECOND)

    updateHealthRegen: (nextPointDate) =>
      if nextPointDate == undefined
        nextPointDate = @getNextHealthPointDate()

      if (moment().isAfter(nextPointDate))
        @model.totalHealthGained += 1
        @model.healthModifiedDate = nextPointDate

        if @model.health > @model.fitness
          healthReduction = @model.health - @model.fitness
          @model.totalHealthGained -= healthReduction

        @model.updateHealth()
        @model.save()

      else
        @model.nextHealthPointIn = parseInt(Math.abs(moment().diff(nextPointDate) / 1000))

    addOfflineHealth: =>
      nextPointDate = @getNextHealthPointDate()
      while moment().isAfter(nextPointDate)
        @updateHealthRegen nextPointDate
        nextPointDate = @getNextHealthPointDate()
      @model.updateHealth()

    getNextHealthPointDate: =>
      moment(@model.healthModifiedDate).add(@getHealthRegenTime(), 'seconds')

    getHealthRegenTime: =>
      pointInMinutes = ENERGY_REGEN_TIME / @model.fitness
      pointInSeconds = pointInMinutes * 60
      parseInt(pointInSeconds)

    canSpendHealth: (spend) =>
      @model.health >= spend

    spendHealth: (spend) =>
      throw new Error "Cannot spend health" if !@canSpendHealth spend
      @model.totalHealthUsed += spend
      @addWarmth(spend)
      @model.updateHealth()
      @model.save()

    isHealthFull: =>
      @model.health >= @model.fitness
