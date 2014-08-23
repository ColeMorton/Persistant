'use strict'

describe 'Service: actionFactory', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  actionFactory = undefined
  beforeEach inject (_actionFactory_) ->
    actionFactory = _actionFactory_

  it 'should do something', ->
    expect(!!actionFactory).toBe true
