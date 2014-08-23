'use strict'

describe 'Service: healthFactory', ->

  # load the service's module
  beforeEach module 'persistantApp'

  getFirstTricker = ->
    tricker = mockTrickers[0]
    tricker.lastModifiedDate = moment()
    tricker.fitnessLossDate = moment()
    tricker.healthModifiedDate = moment()
    return tricker

  xit 'should load health', ->
    expect(!!tricker.health).toBe true

  it 'should not add health for no offline time', inject((trickerFactory) ->
    tricker = getFirstTricker()
    tricker = new trickerFactory tricker
    expect(tricker.model.health).toEqual 80
  )

  it 'should add health for offline time', inject((trickerFactory) ->
    tricker = getFirstTricker()
    tricker.healthModifiedDate = moment().subtract(1, 'days')
    tricker = new trickerFactory tricker
    expect(tricker.model.health).toEqual 100
  )

  xit 'should regenerate health', ->
    currentHealth = healthFactory.model.health
    console.log healthFactory.model.health
