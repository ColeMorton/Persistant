'use strict'

describe 'Service: warmthFactory', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  warmthFactory = undefined
  beforeEach inject (_warmthFactory_) ->
    warmthFactory = _warmthFactory_

  it 'should do something', ->
    expect(!!warmthFactory).toBe true
