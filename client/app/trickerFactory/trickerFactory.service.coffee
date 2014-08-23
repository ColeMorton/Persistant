'use strict'

angular.module 'persistantApp'
.factory 'trickerFactory', ($http, $timeout, healthierFactory) ->
  class Tricker

    save = ->
      @lastModified = moment()
      $http.put '/api/rests/' + @_id, this

    constructor: (_tricker_) ->
      @model = _tricker_
      @model.save = save
      health = new healthierFactory(@model)
