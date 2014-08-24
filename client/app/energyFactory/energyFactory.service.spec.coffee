'use strict'

describe 'Service: energyFactory', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  energyFactory = undefined
  beforeEach inject (_energyFactory_) ->
    energyFactory = _energyFactory_

  it 'should do something', ->
    expect(!!energyFactory).toBe true
