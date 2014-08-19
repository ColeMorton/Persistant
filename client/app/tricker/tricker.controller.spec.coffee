'use strict'

describe 'Controller: TrickerCtrl', ->

  # load the controller's module
  beforeEach module 'persistantApp'
  TrickerCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    TrickerCtrl = $controller 'TrickerCtrl',
      $scope: scope

  it 'should ...', ->
    expect(1).toEqual 1
