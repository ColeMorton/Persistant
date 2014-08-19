'use strict'

angular.module 'persistantApp'
.service 'healthierFactory', ($timeout) ->
  class Health

    RECHARGE_TIME = 30
    MINUTE = 60000
    SECOND = 1000

    secondTicker: =>
      @model.second += 1
      @updateHealthIncrementCountdown()
      @mySecondTicker = $timeout(@secondTicker, 1000)

    updateHealthIncrementCountdown: =>
      if (@model.nextHealthPointIn != 1)
        @model.nextHealthPointIn -= 1

    getHealthIncrementLength: =>
      totalRechargeTimeInSeconds = RECHARGE_TIME * MINUTE
      pointRechargeTimeInSeconds = totalRechargeTimeInSeconds / @model.fitness
      parseInt(pointRechargeTimeInSeconds / SECOND)

    incrementHealth: =>
      $timeout(@incrementHealth, @healthIncrementLength)

    constructor: (_tricker_) ->
      @model = _tricker_
      @model.test = "Hello Bob!!!"
      @model.second = 0
      @model.healthIncrementLength = @getHealthIncrementLength()
      @model.nextHealthPointIn = @getHealthIncrementLength() + 1

      # @incrementHealth()
      @updateHealthIncrementCountdown()
      @secondTicker()



