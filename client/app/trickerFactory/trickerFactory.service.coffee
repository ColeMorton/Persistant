'use strict'

angular.module 'persistantApp'
.factory 'trickerFactory', ($http, $timeout) ->

  # Service logic
  # ...
  meaningOfLife = 42

  someMethod = ->
    meaningOfLife

  init = ->
    console.log "Tricker init"

  # Public API here
  someMethod: someMethod
  init: init
