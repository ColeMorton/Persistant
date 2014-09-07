'use strict'

angular.module 'persistantApp'
.service 'trickerClass', ($http, $timeout, energyClass, fitnessClass, warmthClass, actionClass, trickFactory, TRICK_TYPES) ->
  class Tricker

    save = ->
      @lastModified = moment()
      $http.put '/api/trickers/' + @_id, this

    reset = ->
      this.age = 13
      this.energyModifiedDate = moment()
      this.totalEnergyGained = 120
      this.totalEnergyUsed = 0
      this.fitness = 120
      this.fitnessModifiedDate = moment()
      this.warmth = 10
      this.warmthModifiedDate = moment()
      this.hookSkill = 0
      this.updateCost TRICK_TYPES.HOOK
      this.save()
      this.updateEnergy()

    updateEnergy = ->
      this.energy = this.totalEnergyGained - this.totalEnergyUsed

    updateCost = (trickId) ->
      console.log "Current cost: " + this["cost" + TRICK_TYPES.getName(trickId)]
      console.log "New cost: " + trickFactory.getCost this, TRICK_TYPES.HOOK
      console.log ""
      this["cost" + TRICK_TYPES.getName(trickId)] = trickFactory.getCost this, TRICK_TYPES.HOOK

    addSkill = (trickId) ->
      this.hookSkill += TRICK_TYPES.getTrickSuccessSkill TRICK_TYPES.HOOK
      this.hookSkill = 100 if this.hookSkill > 100
      this.save()

    constructor: (tricker) ->
      @model = tricker
      @model.save = save
      @model.reset = reset
      @model.updateEnergy = updateEnergy
      @model.updateCost = updateCost
      @model.addSkill = addSkill
      @warmth = new warmthClass @model
      @energy = new energyClass @model, @warmth
      @fitness = new fitnessClass @model
      @action = new actionClass @model

      @model.updateEnergy()
      @model.updateCost TRICK_TYPES.HOOK
