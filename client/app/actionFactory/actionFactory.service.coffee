'use strict'

angular.module 'persistantApp'
.service 'actionFactory', ->
  class Action

    constructor: (tricker, health) ->
      @model = tricker
      @health = health

    run: (energyPercentage) =>
      energyAmount = @getRunEnerygyAmount energyPercentage
      return if !@health.canSpendHealth energyAmount
      @health.spendHealth energyAmount
      @health.addFitness @getFitnessAddition energyPercentage

    getRunEnerygyAmount: (energyPercentage) =>
      parseInt((energyPercentage / 100) * @model.health)

    getFitnessAddition: (energyPercentage) =>
      energy = energyPercentage / 6
      result = parseInt((energy / 100) * @model.fitness)
      return result
