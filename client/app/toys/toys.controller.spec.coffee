'use strict'

describe 'Controller: ToysCtrl', ->

  # load the controller's module
  beforeEach module 'persistantApp'
  ToysCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ToysCtrl = $controller 'ToysCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
