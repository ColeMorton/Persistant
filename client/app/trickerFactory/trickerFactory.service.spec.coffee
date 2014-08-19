'use strict'

describe 'Service: trickerFactory', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  trickerFactory = undefined
  beforeEach inject (_trickerFactory_) ->
    trickerFactory = _trickerFactory_

  it 'should do something', ->
    expect(!!trickerFactory).toBe true