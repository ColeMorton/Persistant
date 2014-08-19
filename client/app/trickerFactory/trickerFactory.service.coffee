'use strict'

angular.module 'persistantApp'
.factory 'trickerFactory', ($http, $timeout, healthierFactory) ->
  class Tricker

    constructor: (_tricker_) ->
      @model = _tricker_
      health = new healthierFactory(@model)
