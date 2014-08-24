'use strict'

angular.module 'persistantApp'
.service 'actionFactory', ->
  class Action

    constructor: (tricker, health) ->
      @model = tricker
      @health = health

    run: (energyPercentage) =>
      energyAmount = @getEnerygyAmount energyPercentage
      return if !@health.canSpendHealth energyAmount
      @health.spendHealth energyAmount
      @health.addFitness @getFitnessAddition energyPercentage

    warmUp: =>
      energyAmount = @getEnerygyAmount 10
      return if !@health.canSpendHealth energyAmount
      @health.spendHealth energyAmount
      @health.addWarmth (energyAmount * 3)

    hook: (energyPercentage) =>
      energyAmount = @getEnerygyAmount energyPercentage
      return if !@health.canSpendHealth energyAmount
      @health.spendHealth energyAmount

    getEnerygyAmount: (energyPercentage) =>
      parseInt((energyPercentage / 100) * @model.health)

    getFitnessAddition: (energyPercentage) =>
      energy = energyPercentage / 6
      result = parseInt((energy / 100) * @model.fitness)
      return result
