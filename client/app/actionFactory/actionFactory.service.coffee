'use strict'

angular.module 'persistantApp'
.service 'actionFactory', ->
  class Action

    constructor: (tricker) ->
      @model = tricker

    run: (energyPercentage) ->
      energyAmount = @getEnergyAmount energyPercentage
      return if !@model.canSpendEnergy energyAmount
      @model.spendEnergy energyAmount
      @model.addFitness @getFitnessAddition energyPercentage

    warmUp: ->
      energyAmount = @getEnergyAmount 100, 5
      return if !@model.canSpendEnergy energyAmount
      @model.spendEnergy energyAmount
      @model.addWarmth 15

    hook: (energyPercentage) ->
      energyAmount = @getEnergyAmount energyPercentage, 10
      return if !@model.canSpendEnergy energyAmount
      @model.spendEnergy energyAmount

    getEnergyAmount: (energyPercentage, maximum) ->
      maximum = @model.energy if maximum == undefined
      parseInt((energyPercentage / 100) * maximum)

    getFitnessAddition: (energyPercentage) ->
      energy = energyPercentage / 6
      result = parseInt((energy / 100) * @model.fitness)
      return result
