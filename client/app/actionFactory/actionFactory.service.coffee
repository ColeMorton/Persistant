'use strict'

angular.module 'persistantApp'
.service 'actionFactory', ->
  class Action

    RUN_EXPENDITURE = 20

    constructor: (tricker, health) ->
      @model = tricker
      @health = health

    run: =>
      return if !@health.canSpendHealth 10
      @health.spendHealth @getRunExpenditure()
      @health.addFitness @getFitnessAddition()

    getRunExpenditure: =>
      parseInt((RUN_EXPENDITURE / 100) * @model.health)

    getFitnessAddition: =>
      spend = RUN_EXPENDITURE / 6
      result = parseInt((spend / 100) * @model.fitness)
      return result
