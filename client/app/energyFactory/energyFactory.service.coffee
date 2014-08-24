'use strict'

angular.module 'persistantApp'
.service 'energyFactory', ($timeout) ->
  class Energy

    ENERGY_REGEN_TIME = 480
    MINUTE = 60000
    SECOND = 1000

    mySecondTicker = null

    constructor: (tricker) ->
      @model = tricker
      @model.energyIncrementLength = @getEnergyRegenTime()
      @addOfflineEnergy()
      @secondTicker()

    secondTicker: =>
      @updateEnergyRegen()
      mySecondTicker = $timeout(@secondTicker, SECOND)

    updateEnergyRegen: (nextPointDate) =>
      if nextPointDate == undefined
        nextPointDate = @getNextEnergyPointDate()

      if (moment().isAfter(nextPointDate))
        @model.totalEnergyGained += 1
        @model.energyModifiedDate = nextPointDate

        if @model.energy > @model.fitness
          energyReduction = @model.energy - @model.fitness
          @model.totalEnergyGained -= energyReduction

        @model.updateEnergy()
        @model.save()

      else
        @model.nextEnergyPointIn = parseInt(Math.abs(moment().diff(nextPointDate) / 1000))

    addOfflineEnergy: =>
      nextPointDate = @getNextEnergyPointDate()
      while moment().isAfter(nextPointDate)
        @updateEnergyRegen nextPointDate
        nextPointDate = @getNextEnergyPointDate()
      @model.updateEnergy()

    getNextEnergyPointDate: =>
      moment(@model.energyModifiedDate).add(@getEnergyRegenTime(), 'seconds')

    getEnergyRegenTime: =>
      pointInMinutes = ENERGY_REGEN_TIME / @model.fitness
      pointInSeconds = pointInMinutes * 60
      parseInt(pointInSeconds)

    canSpendEnergy: (spend) =>
      @model.energy >= spend

    spendEnergy: (spend) =>
      throw new Error "Cannot spend energy" if !@canSpendEnergy spend
      @model.totalEnergyUsed += spend
      @addWarmth(spend)
      @model.updateEnergy()
      @model.save()

    isEnergyFull: =>
      @model.energy >= @model.fitness