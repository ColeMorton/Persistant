'use strict'

describe 'Service: fitnessClass', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  fitnessClass = undefined
  beforeEach inject (_fitnessClass_) ->
    fitnessClass = _fitnessClass_

  it 'should do something', ->
    expect(!!fitnessClass).toBe true
