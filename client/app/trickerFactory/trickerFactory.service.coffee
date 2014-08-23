'use strict'

angular.module 'persistantApp'
.factory 'trickerFactory', ($http, $timeout, healthFactory, actionFactory) ->
  class Tricker

    save = ->
      @lastModified = moment()
      $http.put '/api/trickers/' + @_id, this

    reset = ->
      this.age = 13
      this.totalHealthGained = 50
      this.totalHealthUsed = 0
      this.fitness = 100
      this.fitnessLossDate = moment()
      this.save()

    constructor: (tricker) ->
      @model = tricker
      @model.save = save
      @model.reset = reset
      @health = new healthFactory(@model)
      @action = new actionFactory(@model, @health)
