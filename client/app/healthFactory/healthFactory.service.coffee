'use strict'

angular.module 'persistantApp'
.factory 'healthFactory', ($http, $timeout) ->

  # Service logic
  # ...
  RECHARGE_TIME = 30
  MINUTE = 60000

  meaningOfLife = 42
  tricker = null
  healthUpdated = null
  nextHealthPointIn = 0
  nextHealthPointInUpdate = null

  someMethod = ->
    meaningOfLife

  init = (_tricker_, _healthUpdated_, _nextHealthPointInUpdate_) ->
    tricker = _tricker_
    healthUpdated = _healthUpdated_
    nextHealthPointInUpdate = _nextHealthPointInUpdate_
    addOfftimeTime()
    incrementHealth()

  getHealthPointRefreshTime = ->
    parseInt(healthIncrementLength() / 1000)

  addOfftimeTime = ->
    offlineTime = getOfflineHealth()
    # console.log "getOfflineHealth: " + offlineTime
    if (getHealth() + offlineTime > tricker.fitness)
      tricker.totalHealthGained = tricker.totalHealthUsed + tricker.fitness
    else
      tricker.totalHealthGained += offlineTime

  getOfflineHealth = ->
    # console.log "Last modified: " + tricker.lastModified
    # console.log "Now: " + moment()
    duration = moment().diff(tricker.lastModified)
    return parseInt(duration / healthIncrementLength())

  healthIncrementLength = ->
    # console.log "healthIncrementLength: " + (RECHARGE_TIME * MINUTE) / tricker.fitness
    return (RECHARGE_TIME * MINUTE) / tricker.fitness

  incrementHealth = ->
    # console.log "incrementHealth"
    updateNextHealthPointIn()
    $timeout(incrementHealth, healthIncrementLength())
    return if isHealthFull()

    tricker.totalHealthGained += 1
    # updatePage()
    healthUpdated(getHealth()) if healthUpdated != null
    updateTricker()

  updateNextHealthPointIn = ->
    if isHealthFull()
      nextHealthPointIn = 0
    else
      nextHealthPointIn = parseInt((healthIncrementLength() / 1000) + 1)

    # console.log "updateNextHealthPointIn: " + nextHealthPointIn
    nextHealthPointInUpdate nextHealthPointIn

  updateTricker = ->
    tricker.lastModified = moment()
    $http.put '/api/rests/' + tricker._id, tricker

  getHealth = ->
    return tricker.totalHealthGained - tricker.totalHealthUsed

  isHealthFull = ->
    return getHealth() == tricker.fitness

  # Public API here
  someMethod: someMethod
  init: init
  getHealthPointRefreshTime: getHealthPointRefreshTime
  isHealthFull: isHealthFull
  getHealth: getHealth
