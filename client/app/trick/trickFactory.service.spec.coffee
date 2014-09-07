'use strict'

describe 'Service: trickFactory', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  trickFactory = undefined
  beforeEach inject (_trickFactory_) ->
    trickFactory = _trickFactory_

  it 'should do something', ->
    expect(!!trickFactory).toBe true
