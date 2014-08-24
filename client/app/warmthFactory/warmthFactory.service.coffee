'use strict'

angular.module 'persistantApp'
.service 'warmthFactory', ($timeout) ->
  class Warmth

    WARMTH_DEGEN_TIME = 30
    MINUTE = 60000
    SECOND = 1000

    mySecondTicker = null

    constructor: (tricker) ->
      @model = tricker
      @subtractOfflineWarmth()
      @secondTicker()

    secondTicker: =>
      @updateWarmthDegen()
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

    getOfflineWarmth: =>
      duration = moment().diff(@model.warmthModifiedDate) / SECOND
      parseInt(duration / @getWarmthDegenTime())

    getNextWarmthPointDate: =>
      moment(@model.warmthModifiedDate).add(@getWarmthDegenTime(), 'seconds')

    getWarmthDegenTime: =>
      totalInSeconds = WARMTH_DEGEN_TIME * MINUTE
      pointInSeconds = totalInSeconds / 100
      parseInt(pointInSeconds / SECOND)

    isWarmthEmpty: =>
      @model.warmth <= 0
