'use strict'

angular.module 'persistantApp'
.service 'actionClass', (trickFactory, TRICK_TYPES) ->
  class Action

    HOOK_DIFFERCULTY = 200

    constructor: (@tricker) ->

    trickSuccess = (tricker, focus) ->
      console.log "Success!"
      trickFactory.addTrickAttemptSkill tricker, TRICK_TYPES.HOOK
      trickFactory.addTrickSuccessSkill tricker, TRICK_TYPES.HOOK if focus == 1
      trickFactory.addTrickStyle tricker, TRICK_TYPES.HOOK if focus == 2
      tricker.addFitness 1

    trickFailed = (tricker) ->
      console.log "Fail"
      trickFactory.addTrickAttemptSkill tricker, TRICK_TYPES.HOOK
      tricker.getInjury HOOK_DIFFERCULTY

    # run: (energyPercentage) =>
    #   energyAmount = @getEnergyAmount energyPercentage
    #   return if !@tricker.canSpendEnergy energyAmount
    #   @tricker.spendEnergy energyAmount
    #   @tricker.addFitness @getFitnessAddition energyAmount

    # warmUp: =>
    #   energyAmount = @getEnergyAmount 100
    #   return if !@tricker.canSpendEnergy energyAmount
    #   @tricker.spendEnergy energyAmount
    #   @tricker.addWarmth 40

    hook: (focus) =>
      energyAmount = trickFactory.getCost @tricker, TRICK_TYPES.HOOK
      return if !@tricker.canSpendEnergy energyAmount
      @tricker.spendEnergy energyAmount
      @doTrick energyAmount, TRICK_TYPES.HOOK, focus
      trickFactory.updateBelt @tricker, TRICK_TYPES.HOOK
      trickFactory.updateCost @tricker, TRICK_TYPES.HOOK
      return

    # getEnergyAmount: (energyPercentage) ->
    #   parseInt((energyPercentage / 100) * 5)

    # getFitnessAddition: (energyAmount) ->
    #   parseInt(energyAmount / 5)

    doTrick: (energy, trickId, focus) =>
      chance = trickFactory.getChance @tricker, trickId, focus
      roll = parseInt(Math.random() * 100)
      console.log 'Chance: ' + chance
      if chance >= roll then trickSuccess(@tricker, focus) else trickFailed(@tricker)
      return
