'use strict'

angular.module 'persistantApp'
.service 'actionFactory', ->
  class Action

    HOOK_DIFFERCULTY = 200

    trickSuccess = (model) ->
      console.log "Success!"
      model.hookSkill += 5
      model.addFitness 1

    trickFailed = (model) ->
      console.log "Fail"
      model.hookSkill += 1
      model.getInjury HOOK_DIFFERCULTY

    constructor: (tricker) ->
      @model = tricker

    run: (energyPercentage) ->
      energyAmount = @getEnergyAmount energyPercentage
      return if !@model.canSpendEnergy energyAmount
      @model.spendEnergy energyAmount
      @model.addFitness @getFitnessAddition energyAmount

    warmUp: ->
      energyAmount = @getEnergyAmount 100, 10
      return if !@model.canSpendEnergy energyAmount
      @model.spendEnergy energyAmount
      @model.addWarmth 40

    hook: (energyPercentage) ->
      energyAmount = @getEnergyAmount energyPercentage, 10
      return if !@model.canSpendEnergy energyAmount
      @model.spendEnergy energyAmount
      result = @doTrick energyPercentage, @model.hookSkill

    getEnergyAmount: (energyPercentage, maximum) ->
      maximum = @model.energy - 1 if maximum == undefined
      parseInt((energyPercentage / 100) * maximum)

    getFitnessAddition: (energyAmount) ->
      parseInt(energyAmount / 5)

    doTrick: (energyPercentage, skill) =>
      differculty = HOOK_DIFFERCULTY
      energy = energyPercentage * energyPercentage
      chance = (energy / differculty) + skill
      roll = parseInt(Math.random() * 100)
      console.log 'Chance: ' + chance
      if chance >= roll then trickSuccess(@model) else trickFailed(@model)
      @model.save()
