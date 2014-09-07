'use strict'

angular.module 'persistantApp'
.service 'fitnessClass', ($timeout) ->
  class Fitness

    FITNESS_DEGEN_TIME = 14400
    MINUTE = 60000
    SECOND = 1000
    MAX_FITNESS_ADDITION = 15
    MIN_FITNESS = 80

    mySecondTicker = null

    constructor: (@tricker) ->
      @tricker.addFitness = addFitness
      @tricker.removeFitness = removeFitness
      @tricker.getInjury = getInjury

      subtractOfflineFitness @tricker
      @secondTicker()

    secondTicker: =>
      updateFitnessDegen @tricker
      mySecondTicker = $timeout(@secondTicker, SECOND)

    getNextFitnessPointDate = (tricker) ->
      moment(tricker.fitnessModifiedDate).add(getFitnessDegenTime(), 'seconds')

    getFitnessDegenTime = ->
      totalInSeconds = FITNESS_DEGEN_TIME * MINUTE
      pointInSeconds = totalInSeconds / 100
      parseInt(pointInSeconds / SECOND)

    subtractOfflineFitness = (tricker) ->
      nextPointDate = getNextFitnessPointDate tricker
      while moment().isAfter(nextPointDate)
        tricker.removeFitness 1
        tricker.fitnessModifiedDate = nextPointDate
        nextPointDate = getNextFitnessPointDate tricker

    updateFitnessDegen = (tricker) ->
      nextPointDate = getNextFitnessPointDate tricker
      if (moment().isAfter(nextPointDate))
        tricker.removeFitness 1
      else
        tricker.nextFitnessPointIn = parseInt(Math.abs(moment().diff(nextPointDate) / 1000))

    isFitnessEmpty = (tricker) ->
      tricker.fitness <= 80

    addFitness = (fitness) ->
      nextPointDate = getNextFitnessPointDate this
      fitness = MAX_FITNESS_ADDITION if fitness > MAX_FITNESS_ADDITION
      this.fitness += fitness
      this.fitnessModifiedDate = nextPointDate
      this.save()

    removeFitness = (fitness) ->
      nextPointDate = getNextFitnessPointDate this
      this.fitness -= fitness
      this.fitnessModifiedDate = nextPointDate
      this.save()

      if this.energy > this.fitness
        energyReduction = this.energy - this.fitness
        this.spendEnergy energyReduction

      return

    getInjury = (differculty) ->
      roll = parseInt(Math.random() * 100)
      warmth = (100 - this.warmth) / 6
      differculty = differculty / 30
      result = (warmth + differculty) >= roll
      if result
        this.injuredDate = moment()
        fitnessReduction = parseInt(this.fitness * 0.8)
        this.removeFitness fitnessReduction
        this.save()
        console.log "You're injured!!"
