'use strict'

describe 'Service: actionClass', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  actionClass = undefined
  beforeEach inject (_actionClass_) ->
    actionClass = _actionClass_

  it 'should do something', ->
    expect(!!actionClass).toBe true
