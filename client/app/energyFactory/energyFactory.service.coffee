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
      @model.canSpendEnergy = canSpendEnergy
      @model.spendEnergy = spendEnergy
      @model.reduceEnergy = reduceEnergy
      @addOfflineEnergy()
      @secondTicker()

    secondTicker: =>
      @updateEnergyRegen()
      mySecondTicker = $timeout(@secondTicker, SECOND)

    updateEnergyRegen: (nextPointDate) ->
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

    addOfflineEnergy: ->
      nextPointDate = @getNextEnergyPointDate()
      while moment().isAfter(nextPointDate)
        @updateEnergyRegen nextPointDate
        nextPointDate = @getNextEnergyPointDate()
      @model.updateEnergy()

    getNextEnergyPointDate: ->
      moment(@model.energyModifiedDate).add(@getEnergyRegenTime(), 'seconds')

    getEnergyRegenTime: ->
      pointInMinutes = ENERGY_REGEN_TIME / @model.fitness
      pointInSeconds = pointInMinutes * 60
      parseInt(pointInSeconds)

    canSpendEnergy = (spend) ->
      this.energy >= spend

    reduceEnergy = (spend) ->
      this.totalEnergyUsed += spend
      this.updateEnergy()
      this.save()

    spendEnergy = (spend) ->
      throw new Error "Cannot spend energy" if !this.canSpendEnergy spend
      this.totalEnergyUsed += spend
      warmth = this.getWarmthAmountFromEnergy spend
      this.addWarmth warmth
      this.updateEnergy()
      this.save()

    isEnergyFull: ->
      @model.energy >= @model.fitness
