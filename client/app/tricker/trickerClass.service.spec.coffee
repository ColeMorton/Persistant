'use strict'

describe 'Service: trickerClass', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  trickerClass = undefined
  beforeEach inject (_trickerClass_) ->
    trickerClass = _trickerClass_

  it 'should do something', ->
    expect(!!trickerClass).toBe true