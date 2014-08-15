'use strict';

/**
 * @ngdoc function
 * @name persistantApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the persistantApp
 */
angular.module('persistantApp')
  .controller('MainCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
  });
