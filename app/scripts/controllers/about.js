'use strict';

/**
 * @ngdoc function
 * @name persistantApp.controller:AboutCtrl
 * @description
 * # AboutCtrl
 * Controller of the persistantApp
 */
angular.module('persistantApp')
  .controller('AboutCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
  });