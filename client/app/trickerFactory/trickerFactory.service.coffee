'use strict'

angular.module 'persistantApp'
.factory 'trickerFactory', ($http, $timeout, healthierFactory, actionFactory) ->
  class Tricker

    save = ->
      @lastModified = moment()
      $http.put '/api/rests/' + @_id, this

    reset = ->
      this.totalHealthGained = 50
      this.totalHealthUsed = 0
      this.fitness = 100
      this.fitnessLossDate = moment()
      this.save()

    constructor: (tricker) ->
      @model = tricker
      @model.save = save
      @model.reset = reset
      @health = new healthierFactory(@model)
      @action = new actionFactory(@model, @health)
