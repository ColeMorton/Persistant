'use strict'

describe 'Service: healthierFactory', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  healthierFactory = undefined
  beforeEach inject (_healthierFactory_) ->
    healthierFactory = _healthierFactory_

  it 'should do something', ->
    expect(!!healthierFactory).toBe true
