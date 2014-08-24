'use strict'

angular.module 'persistantApp'
.factory 'trickerFactory', ($http, $timeout, healthFactory, fitnessFactory, warmthFactory, actionFactory) ->
  class Tricker

    save = ->
      @lastModified = moment()
      $http.put '/api/trickers/' + @_id, this

    reset = ->
      this.age = 13
      this.healthModifiedDate = moment()
      this.totalHealthGained = 50
      this.totalHealthUsed = 0
      this.fitness = 100
      this.fitnessModifiedDate = moment()
      this.warmth = 50
      this.warmthModifiedDate = moment()
      this.save()

    updateHealth = ->
      this.health = this.totalHealthGained - this.totalHealthUsed

    constructor: (tricker) ->
      @model = tricker
      @model.save = save
      @model.reset = reset
      @model.updateHealth = updateHealth
      @warmth = new warmthFactory(@model)
      @health = new healthFactory(@model)
      @fitness = new fitnessFactory(@model)
      @action = new actionFactory(@model, @health)

      @model.updateHealth()
