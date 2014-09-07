'use strict'

describe 'Service: energyClass', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  energyClass = undefined
  beforeEach inject (_energyClass_) ->
    energyClass = _energyClass_

  it 'should do something', ->
    expect(!!energyClass).toBe true
