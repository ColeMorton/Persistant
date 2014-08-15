'use strict'

describe 'Controller: ToysCtrl', ->

  # load the controller's module
  beforeEach module 'persistantApp'

  ToysCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ToysCtrl = $controller 'ToysCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
