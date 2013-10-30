# Get the context of the canvas element we want to select
###

###

osp = angular.module('osp', ['ngRoute']).config(($routeProvider, $locationProvider) ->
  $routeProvider.when('/controller/:controllerId',
      templateUrl: 'controller.html',
      controller: 'ControllerCntl'
  )
  $routeProvider.when('/controller/:controllerId/sensor/:sensorId',
    templateUrl: 'sensor.html',
    controller: 'SensorCntl'
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
  $scope.currentController = _.find($scope.controllers, (item) ->
    item.id == $routeParams.controllerId
  )

  ospMap.drawMap()

  $scope.name = "ControllerCntl"
  $scope.params = $routeParams

  if $scope.currentController
    $http.get('http://zeitl.com/api/controllers/' + $scope.currentController.id + '/sensors').success((data)->
      $scope.sensors = data
    )
)

osp.controller("SensorCntl", ($scope, $routeParams) ->
  $scope.name = "SensorCntl"
  $scope.params = $routeParams
)
