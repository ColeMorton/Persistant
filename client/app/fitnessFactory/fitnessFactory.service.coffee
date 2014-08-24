'use strict'

angular.module 'persistantApp'
.service 'fitnessFactory', ($timeout) ->
  class Fitness

    FITNESS_DEGEN_TIME = 14400
    MINUTE = 60000
    SECOND = 1000
    MIN_FITNESS = 80

    mySecondTicker = null

    constructor: (tricker) ->
      @model = tricker
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

    subtractOfflineFitness: =>
      nextPointDate = @getNextFitnessPointDate()
      while moment().isAfter(nextPointDate)
        @updateFitnessDegen nextPointDate
        nextPointDate = @getNextFitnessPointDate()

    getNextFitnessPointDate: =>
      moment(@model.fitnessModifiedDate).add(@getFitnessDegenTime(), 'seconds')

    getFitnessDegenTime: =>
      totalInSeconds = FITNESS_DEGEN_TIME * MINUTE
      pointInSeconds = totalInSeconds / 100
      parseInt(pointInSeconds / SECOND)

    isFitnessEmpty: =>
      @model.fitness <= 80
