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

    constructor: (tricker) ->
      @model = tricker
      @model.addFitness = addFitness
      @model.getInjury = getInjury
      @subtractOfflineFitness()
      @secondTicker()

    secondTicker: =>
      @updateFitnessDegen()
      mySecondTicker = $timeout(@secondTicker, SECOND)

    updateFitnessDegen: (nextPointDate) ->
      if nextPointDate == undefined
        nextPointDate = @getNextFitnessPointDate()

      if (moment().isAfter(nextPointDate))
        @model.fitness -= 1
        @model.fitness = MIN_FITNESS if @model.fitness < MIN_FITNESS
        @model.fitnessModifiedDate = nextPointDate

        if @model.health > @model.fitness
          healthReduction = @model.health - @model.fitness
          @model.totalHealthGained -= healthReduction
          @updateHealth()

        @model.save()

      else
        @model.nextFitnessPointIn = parseInt(Math.abs(moment().diff(nextPointDate) / 1000))

    addFitness = (fitness) ->
      fitness = MAX_FITNESS_ADDITION if fitness > MAX_FITNESS_ADDITION
      this.fitness += fitness
      this.fitness = this.maxFitness if this.fitness > this.maxFitness

    subtractOfflineFitness: ->
      nextPointDate = @getNextFitnessPointDate()
      while moment().isAfter(nextPointDate)
        @updateFitnessDegen nextPointDate
        nextPointDate = @getNextFitnessPointDate()

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

    getNextFitnessPointDate: ->
      moment(@model.fitnessModifiedDate).add(@getFitnessDegenTime(), 'seconds')

    getFitnessDegenTime: ->
      totalInSeconds = FITNESS_DEGEN_TIME * MINUTE
      pointInSeconds = totalInSeconds / 100
      parseInt(pointInSeconds / SECOND)

    isFitnessEmpty: ->
      @model.fitness <= 80
