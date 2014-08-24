'use strict'

angular.module 'persistantApp'
.service 'actionFactory', ->
  class Action

    HOOK_DIFFERCULTY = 200

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
      result = @doTrick energyPercentage

    getEnergyAmount: (energyPercentage, maximum) ->
      maximum = @model.energy if maximum == undefined
      parseInt((energyPercentage / 100) * maximum)

    getFitnessAddition: (energyPercentage) ->
      energy = energyPercentage / 6
      result = parseInt((energy / 100) * @model.fitness)
      return result

    doTrick: (energyPercentage) =>
      differculty = HOOK_DIFFERCULTY
      energy = energyPercentage * energyPercentage
      skill = @model.hookSkill
      chance = (energy / differculty) + skill
      roll = parseInt(Math.random() * 100)
      console.log 'Chance: ' + chance
      if chance >= roll
        console.log "Success!!!"
        @model.hookSkill += 5
        @model.fitness += 1
      else
        console.log "Fail..."
        @model.hookSkill += 1
        @model.getInjury HOOK_DIFFERCULTY
      @model.save()




