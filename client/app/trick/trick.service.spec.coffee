'use strict'

describe 'Service: trickService', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  trickService = undefined
  beforeEach inject (_trickService_) ->
    trickService = _trickService_

  it 'should do something', ->
    expect(!!trickService).toBe true
