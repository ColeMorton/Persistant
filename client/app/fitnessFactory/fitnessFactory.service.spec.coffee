'use strict'

describe 'Service: fitnessFactory', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  fitnessFactory = undefined
  beforeEach inject (_fitnessFactory_) ->
    fitnessFactory = _fitnessFactory_

  it 'should do something', ->
    expect(!!fitnessFactory).toBe true
