'use strict'

angular.module 'persistantApp'
.service 'actionFactory', ->
  class Action

    constructor: (tricker, energy, fitness, warmth) ->
      @model = tricker
      @energy = energy
      @fitness = fitness
      @warmth = warmth

    run: (energyPercentage) =>
      energyAmount = @getEnergyAmount energyPercentage
      return if !@energy.canSpendEnergy energyAmount
      @energy.spendEnergy energyAmount
      @fitness.addFitness @getFitnessAddition energyPercentage

    warmUp: =>
      energyAmount = @getEnergyAmount 100, 5
      return if !@energy.canSpendEnergy energyAmount
      @energy.spendEnergy energyAmount
      @warmth.addWarmth 15

    hook: (energyPercentage) =>
      energyAmount = @getEnergyAmount energyPercentage, 10
      return if !@energy.canSpendEnergy energyAmount
      @energy.spendEnergy energyAmount

    getEnergyAmount: (energyPercentage, maximum) =>
      maximum = @model.energy if maximum == undefined
      parseInt((energyPercentage / 100) * maximum)

    getFitnessAddition: (energyPercentage) =>
      energy = energyPercentage / 6
      result = parseInt((energy / 100) * @model.fitness)
      return result
