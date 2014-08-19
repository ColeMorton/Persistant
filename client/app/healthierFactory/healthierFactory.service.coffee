'use strict'

angular.module 'persistantApp'
.service 'healthierFactory', ($timeout) ->
  class Health

    secondTicker: =>
      @model.second += 1
      @mySecondTicker = $timeout(@secondTicker, 1000)

    constructor: (_tricker_) ->
      @model = _tricker_
      @model.test = "Hello Bob!!!"
      @model.second = 0
      @secondTicker()


