angular
.module 'blu', ['ngCookies', 'ngRoute', 'ngMaterial', 'angulartics', 'angulartics.google.analytics']
.config ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl: '/home.html'
      controller:  'HomeController'
      controllerAs: 'controller'
.run ($rootScope, $location) ->
