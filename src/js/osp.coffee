# Get the context of the canvas element we want to select
###

###

osp = angular.module('osp', ['ngRoute']).config(($routeProvider, $locationProvider) ->
  $routeProvider.when('/controller/:controllerId',
      templateUrl: 'controller.html',
      controller: 'ControllerCntl'
  )
  $routeProvider.when('/controller/:controllerId/sensor/:sensorId',
    templateUrl: 'controller.html',
    controller: 'ControllerCntl'
  )

  $locationProvider.html5Mode(false)
)

osp.controller("ControllersCntl", ($scope, $http, $route, $routeParams, $location) ->
  $scope.controllers = []

  $scope.$route = $route
  $scope.$location = $location
  $scope.$routeParams = $routeParams

  $http.get('http://zeitl.com/api/controllers').success((data)->
    $scope.controllers = data
  )
)

osp.controller("ControllerCntl", ($scope, $http, $routeParams) ->
  $scope.name = "ControllerCntl"
  $scope.params = $routeParams

  $http.get('http://zeitl.com/api/controllers/' + $routeParams.controllerId + '/sensors').success((data)->
    $scope.sensors = data
  )

  if $routeParams.sensorId
    $http.get('http://zeitl.com/api/sensors/' + $routeParams.sensorId + '/ticks').success((data)->
      $scope.ticks = data.ticks
    ).then(()->
      ospMap.drawMap($scope.ticks)
    )
)