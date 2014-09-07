'use strict'

describe 'Service: warmthClass', ->

  # load the service's module
  beforeEach module 'persistantApp'

  # instantiate service
  warmthClass = undefined
  beforeEach inject (_warmthClass_) ->
    warmthClass = _warmthClass_

  it 'should do something', ->
    expect(!!warmthClass).toBe true
