'use strict'

angular.module 'persistantApp'
.service 'actionFactory', (energyClass, TRICK_TYPES) ->
  class Action

    HOOK_DIFFERCULTY = 200

    constructor: (@tricker) ->

    trickSuccess = (tricker) ->
      console.log "Success!"
      tricker.hookSkill += 5
      tricker.addFitness 1

    trickFailed = (tricker) ->
      console.log "Fail"
      tricker.hookSkill += 1
      tricker.getInjury HOOK_DIFFERCULTY

    run: (energyPercentage) =>
      energyAmount = @getEnergyAmount energyPercentage
      return if !@tricker.canSpendEnergy energyAmount
      @tricker.spendEnergy energyAmount
      @tricker.addFitness @getFitnessAddition energyAmount

    warmUp: =>
      energyAmount = @getEnergyAmount 100
      return if !@tricker.canSpendEnergy energyAmount
      @tricker.spendEnergy energyAmount
      @tricker.addWarmth 40

    hook: =>
      energyAmount = @getEnergyAmount 10
      return if !@tricker.canSpendEnergy energyAmount
      @tricker.spendEnergy energyAmount
      result = @doTrick 10, @tricker.hookSkill

    getEnergyAmount: (energyPercentage) ->
      parseInt((energyPercentage / 100) * 5)

    getFitnessAddition: (energyAmount) ->
      parseInt(energyAmount / 5)

    doTrick: (energyPercentage, skill) =>
      differculty = HOOK_DIFFERCULTY
      energy = energyPercentage * energyPercentage
      chance = (energy / differculty) + skill
      roll = parseInt(Math.random() * 100)
      console.log 'Chance: ' + chance
      if chance >= roll then trickSuccess(@tricker) else trickFailed(@tricker)
      @tricker.save()
