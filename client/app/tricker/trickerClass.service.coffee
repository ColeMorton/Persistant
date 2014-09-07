'use strict'

angular.module 'persistantApp'
.service 'trickerClass', ($http, $timeout, energyClass, fitnessClass, warmthClass, actionClass, trickFactory, TRICK_TYPES, BELT_TYPES) ->
  class Tricker

    save = ->
      @lastModified = moment()
      $http.put '/api/trickers/' + @_id, this

    reset = ->
      this.age = 13
      this.energyModifiedDate = moment()
      this.totalEnergyGained = 80
      this.totalEnergyUsed = 0
      this.fitness = 80
      this.fitnessModifiedDate = moment()
      this.warmth = 0
      this.warmthModifiedDate = moment()

      this.skillHK = 0
      this.styleHK = 0
      this.beltHK = 0
      this.beltColorHK = ""
      this.skillC1 = 0
      this.styleC1 = 0
      this.beltC1 = 0
      trickFactory.updateCost this, TRICK_TYPES.HOOK

      this.save()
      this.updateEnergy()

    updateEnergy = ->
      this.energy = this.totalEnergyGained - this.totalEnergyUsed

    constructor: (tricker) ->
      @model = tricker
      @model.save = save
      @model.reset = reset
      @model.updateEnergy = updateEnergy
      @warmth = new warmthClass @model
      @energy = new energyClass @model, @warmth
      @fitness = new fitnessClass @model
      @action = new actionClass @model

      @model.updateEnergy()
      trickFactory.updateCost @model, TRICK_TYPES.HOOK
