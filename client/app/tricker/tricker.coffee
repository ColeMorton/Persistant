'use strict'

angular.module 'persistantApp'
.config ($stateProvider) ->
  $stateProvider.state 'tricker',
    url: '/tricker'
    templateUrl: 'app/tricker/tricker.html'
    controller: 'TrickerCtrl'
