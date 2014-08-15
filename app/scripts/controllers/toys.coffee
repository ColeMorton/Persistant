'use strict'

###*
 # @ngdoc function
 # @name persistantApp.controller:ToysCtrl
 # @description
 # # ToysCtrl
 # Controller of the persistantApp
###
angular.module('persistantApp')
  .controller 'ToysCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
