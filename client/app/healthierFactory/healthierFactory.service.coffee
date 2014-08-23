'use strict'

angular.module 'persistantApp'
.service 'healthierFactory', ($timeout) ->
  class Health

    RECHARGE_TIME = 10
    MINUTE = 60000
    SECOND = 1000

    secondTicker: =>
      @model.second += 1
      @updateHealthIncrementCountdown()
      @mySecondTicker = $timeout(@secondTicker, 1000)

    updateHealthIncrementCountdown: =>
      if (@model.nextHealthPointIn != 1)
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

    addOfflineHealth: =>
      offlineTime = @getOfflineTime()
      if (@model.health + offlineTime > @model.fitness)
        @model.totalHealthGained = @model.totalHealthUsed + @model.fitness
      else
        @model.totalHealthGained += offlineTime
      @updateHealth
      @model.save()

    updateHealth: =>
      @model.health = @model.totalHealthGained - @model.totalHealthUsed

    isHealthFull: =>
      @model.health >= @model.fitness

    getOfflineTime: =>
      duration = moment().diff(@model.lastModified) / SECOND
      parseInt(duration / @model.healthIncrementLength)

    canSpendHealth: (soend) =>
      @model.health >= spend

    spendHealth: (spend) =>
      throw new Error "Cannot spend health" if !@canSpendHealth spend
      @model.totalHealthUsed += spend
      @model.updateHealth()
      @model.save()

    constructor: (tricker) ->
      @model = tricker
      @model.second = 0
      @updateHealth()
      @model.healthIncrementLength = @getHealthIncrementLength()
      @model.nextHealthPointIn = @model.healthIncrementLength

      @addOfflineHealth()
      @mySecondTicker = $timeout(@secondTicker, 1000)



