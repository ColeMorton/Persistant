'use strict'

angular.module 'persistantApp'
.config ($stateProvider) ->
  $stateProvider.state 'toys',
    url: '/toys'
    templateUrl: 'app/toys/toys.html'
    controller: 'ToysCtrl'
