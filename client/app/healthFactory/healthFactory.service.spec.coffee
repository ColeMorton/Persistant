'use strict'

describe 'Service: healthFactory', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  healthFactory = undefined
  beforeEach inject (_healthFactory_) ->
    healthFactory = _healthFactory_

  it 'should do something', ->
    expect(!!healthFactory).toBe true