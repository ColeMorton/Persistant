'use strict'

angular.module 'persistantApp'
.factory 'trickerFactory', ($http, $timeout, energyFactory, fitnessFactory, warmthFactory, actionFactory) ->
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
      this.hookSkill = 1
      this.save()
      this.updateEnergy()

    updateEnergy = ->
      this.energy = this.totalEnergyGained - this.totalEnergyUsed

    constructor: (tricker) ->
      @model = tricker
      @model.save = save
      @model.reset = reset
      @model.updateEnergy = updateEnergy
      @warmth = new warmthFactory @model
      @energy = new energyFactory @model, @warmth
      @fitness = new fitnessFactory @model
      @action = new actionFactory @model

      @model.updateEnergy()
