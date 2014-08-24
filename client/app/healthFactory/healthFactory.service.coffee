'use strict'

angular.module 'persistantApp'
.service 'healthFactory', ($timeout) ->
  class Health

    ENERGY_REGEN_TIME = 480
    WARMTH_DEGEN_TIME = 30
    MINUTE = 60000
    SECOND = 1000

    mySecondTicker = null

    constructor: (tricker) ->
      @model = tricker
      @model.healthIncrementLength = @getHealthRegenTime()

      @subtractOfflineWarmth()
      @addOfflineHealth()

      @secondTicker()

    secondTicker: =>
      @updateWarmthDegen()
      @updateHealthRegen()
      mySecondTicker = $timeout(@secondTicker, SECOND)

    updateWarmthDegen: (nextPointDate) ->
      if nextPointDate == undefined
        nextPointDate = @getNextWarmthPointDate()

      if (moment().isAfter(nextPointDate))
        @model.warmth -= 1
        @model.warmth = 0 if @model.warmth < 0
        @model.warmthModifiedDate = nextPointDate
        @model.save()

      else
        @model.nextWarmthPointIn = parseInt(Math.abs(moment().diff(nextPointDate) / 1000))

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

    addWarmth: (energyUsed) =>
      warmth =  (energyUsed / @model.fitness) * 100
      @model.warmth += parseInt warmth
      @model.warmth = 100 if @model.warmth > 100
      @model.save()

    subtractOfflineWarmth: =>
      nextPointDate = @getNextWarmthPointDate()
      while moment().isAfter(nextPointDate)
        @updateWarmthDegen nextPointDate
        nextPointDate = @getNextWarmthPointDate()

    addOfflineHealth: =>
      nextPointDate = @getNextHealthPointDate()
      while moment().isAfter(nextPointDate)
        @updateHealthRegen nextPointDate
        nextPointDate = @getNextHealthPointDate()
      @model.updateHealth()

    getOfflineWarmth: =>
      duration = moment().diff(@model.warmthModifiedDate) / SECOND
      parseInt(duration / @getWarmthDegenTime())

    getNextHealthPointDate: =>
      moment(@model.healthModifiedDate).add(@getHealthRegenTime(), 'seconds')

    getNextWarmthPointDate: =>
      moment(@model.warmthModifiedDate).add(@getWarmthDegenTime(), 'seconds')

    getHealthRegenTime: =>
      pointInMinutes = ENERGY_REGEN_TIME / @model.fitness
      pointInSeconds = pointInMinutes * 60
      parseInt(pointInSeconds)

    getWarmthDegenTime: =>
      totalInSeconds = WARMTH_DEGEN_TIME * MINUTE
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
      @model.updateHealth()
      @model.save()

    isHealthFull: =>
      @model.health >= @model.fitness

    isWarmthEmpty: =>
      @model.warmth <= 0
