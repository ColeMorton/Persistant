'use strict'

angular.module 'persistantApp'
.service 'warmthFactory', ($timeout) ->
  class Warmth

    WARMTH_DEGEN_TIME = 30
    MINUTE = 60000
    SECOND = 1000

    mySecondTicker = null

    updateWarmthDegen = (tricker, nextPointDate) ->
      if nextPointDate == undefined
        nextPointDate = getNextWarmthPointDate tricker

      if (moment().isAfter(nextPointDate))
        tricker.warmth -= 1
        tricker.warmth = 0 if tricker.warmth < 0
        tricker.warmthModifiedDate = nextPointDate
        tricker.save()
      else
        tricker.nextWarmthPointIn = parseInt(Math.abs(moment().diff(nextPointDate) / 1000))

    addWarmth = (warmth) ->
      this.warmth += parseInt warmth
      this.warmth = 100 if this.warmth > 100
      this.save()

    subtractOfflineWarmth = (tricker) ->
      nextPointDate = getNextWarmthPointDate tricker
      while moment().isAfter(nextPointDate)
        updateWarmthDegen tricker, nextPointDate
        nextPointDate = getNextWarmthPointDate tricker

    getNextWarmthPointDate = (tricker) ->
      moment(tricker.warmthModifiedDate).add(getWarmthDegenTime(), 'seconds')

    getWarmthDegenTime = ->
      totalInSeconds = WARMTH_DEGEN_TIME * MINUTE
      pointInSeconds = totalInSeconds / 100
      parseInt(pointInSeconds / SECOND)

    getWarmthAmountFromEnergy = (energy) ->
      parseInt((energy / this.fitness) * 100)

    isWarmthEmpty = ->
      @model.warmth <= 0

    constructor: (tricker) ->
      @tricker = tricker
      @tricker.getWarmthAmountFromEnergy = getWarmthAmountFromEnergy
      @tricker.addWarmth = addWarmth

      subtractOfflineWarmth tricker
      @secondTicker()

    secondTicker: =>
      updateWarmthDegen @tricker
      mySecondTicker = $timeout(@secondTicker, SECOND)
