'use strict'

angular.module 'persistantApp'
.service 'energyClass', ($timeout) ->
  class Energy

    ENERGY_REGEN_TIME = 480
    # ENERGY_REGEN_TIME = 10
    MINUTE = 60000
    SECOND = 1000

    mySecondTicker = null

    constructor: (@tricker) ->
      @tricker.energyIncrementLength = getEnergyRegenTime @tricker
      @tricker.addEnergy = addEnergy
      @tricker.canSpendEnergy = canSpendEnergy
      @tricker.spendEnergy = spendEnergy
      @tricker.reduceEnergy = reduceEnergy

      addOfflineEnergy @tricker
      @secondTicker()

    secondTicker: =>
      updateFitnessDegen @tricker
      mySecondTicker = $timeout(@secondTicker, SECOND)

    getNextEnergyPointDate = (tricker) ->
      moment(tricker.energyModifiedDate).add(getEnergyRegenTime(tricker), 'seconds')

    getEnergyRegenTime = (tricker) ->
      pointInMinutes = ENERGY_REGEN_TIME / tricker.fitness
      pointInSeconds = pointInMinutes * 60
      parseInt(pointInSeconds)

    addOfflineEnergy = (tricker) ->
      nextPointDate = getNextEnergyPointDate tricker
      while moment().isAfter(nextPointDate)
        tricker.addEnergy 1
        tricker.energyModifiedDate = nextPointDate
        nextPointDate = getNextEnergyPointDate tricker

    updateFitnessDegen = (tricker) ->
      nextPointDate = getNextEnergyPointDate tricker
      if (moment().isAfter(nextPointDate))
        tricker.addEnergy 1
      else
        tricker.nextEnergyPointIn = parseInt(Math.abs(moment().diff(nextPointDate) / 1000))

    addEnergy = (energy) ->
      nextPointDate = getNextEnergyPointDate this
      this.totalEnergyGained += 1
      this.energyModifiedDate = nextPointDate

      if this.energy > this.fitness
        energyReduction = this.energy - this.fitness
        this.totalEnergyGained -= energyReduction

      this.updateEnergy()
      this.save()

    canSpendEnergy = (spend) ->
      this.energy > spend

    reduceEnergy = (spend) ->
      if this.energy < spend
        this.totalEnergyUsed == this.totalEnergyGained
      else
        this.totalEnergyUsed += spend
      this.updateEnergy()
      this.save()

    spendEnergy = (spend) ->
      throw new Error "Cannot spend energy" if !this.canSpendEnergy spend
      this.totalEnergyUsed += spend
      warmth = this.getWarmthAmountFromEnergy spend * 2
      this.addWarmth warmth
      this.updateEnergy()
      this.save()

    # isEnergyFull = ->
    #   @model.energy >= @model.fitness
