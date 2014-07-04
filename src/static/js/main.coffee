require.config
  paths : 
      'jquery'        : '/bower/jquery/dist/jquery.min'
      'underscore'    : '/bower/underscore/underscore'
      'angular'       : '/bower/angular/angular'
      'angular-route' : '/bower/angular-route/angular-route'

  shim :  
    'underscore' :
      exports : '_'
    'angular' : 
      exports : 'angular'
    'angular-route' : 
      deps : ['angular']

define ['jquery','underscore','angular','angular-route','login_controller'], ($,_,angular,angular_route,login_controller) ->

  angular.module('app',['ngRoute'])
      .config ($routeProvider) ->
        $routeProvider
        .when '/',
          templateUrl : 'partials/landing_page.html'
        .when '/login',
          templateUrl : 'partials/login_page.html'  
        .otherwise
          redirectTo : '/'
      .controller('login_controller',login_controller)

  $ ()->
    angular.bootstrap document,['app']
    

