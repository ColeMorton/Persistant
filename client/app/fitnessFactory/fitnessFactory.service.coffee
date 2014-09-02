'use strict'

angular.module 'persistantApp'
.service 'fitnessFactory', ($timeout) ->
  class Fitness

    FITNESS_DEGEN_TIME = 14400
    MINUTE = 60000
    SECOND = 1000
    MAX_FITNESS_ADDITION = 15
    MIN_FITNESS = 80

    mySecondTicker = null

    getNextFitnessPointDate = (tricker) ->
      moment(tricker.fitnessModifiedDate).add(getFitnessDegenTime(), 'seconds')

    getFitnessDegenTime = ->
      totalInSeconds = FITNESS_DEGEN_TIME * MINUTE
      pointInSeconds = totalInSeconds / 100
      parseInt(pointInSeconds / SECOND)

    subtractOfflineFitness = (tricker) ->
      nextPointDate = getNextFitnessPointDate tricker
      while moment().isAfter(nextPointDate)
        tricker.removeFitness 1, nextPointDate
        nextPointDate = getNextFitnessPointDate tricker

    updateFitnessDegen = (tricker) ->
      nextPointDate = getNextFitnessPointDate tricker

      if (moment().isAfter(nextPointDate))
        tricker.removeFitness 1, nextPointDate
      else
        tricker.nextFitnessPointIn = parseInt(Math.abs(moment().diff(nextPointDate) / 1000))

    isFitnessEmpty = (tricker) ->
      tricker.fitness <= 80

    addFitness = (fitness) ->
      fitness = MAX_FITNESS_ADDITION if fitness > MAX_FITNESS_ADDITION
      this.fitness += fitness
      this.fitness = this.maxFitness if this.fitness > this.maxFitness

    removeFitness = (fitness, nextPointDate) ->
      this.fitness -= fitness
      this.fitness = MIN_FITNESS if this.fitness < MIN_FITNESS
      this.fitnessModifiedDate = nextPointDate

      if this.energy > this.fitness
        energyReduction = this.energy - this.fitness
        this.totalEnergyGained -= energyReduction
        this.updateEnergy()

      this.save()

    getInjury = (differculty) ->
      this.reduceEnergy 10
      roll = parseInt(Math.random() * 100)
      warmth = (100 - this.warmth) / 6
      differculty = differculty / 30
      result = (warmth + differculty) >= roll
      if result
        this.injuredDate = moment()
        this.maxFitness = 30
        this.fitness = 30

        if this.energy > this.fitness
          energyReduction = this.energy - this.fitness
          this.totalEnergyGained -= energyReduction

        this.save()
        console.log "You're injured!!"

    constructor: (tricker) ->
      @tricker = tricker
      @tricker.addFitness = addFitness
      @tricker.removeFitness = removeFitness
      @tricker.getInjury = getInjury

      subtractOfflineFitness tricker
      @secondTicker()

    secondTicker: =>
      updateFitnessDegen @tricker
      mySecondTicker = $timeout(@secondTicker, SECOND)
