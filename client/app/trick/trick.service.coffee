'use strict'

angular.module 'persistantApp'
.service 'trickService', (TRICK_TYPES) ->
  class Trick

    constructor: (@tricker) ->
      @tricker.costHook = 5
