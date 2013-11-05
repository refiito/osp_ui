# Set up router
osp = angular.module('osp', ['ngRoute']).config ($routeProvider, $locationProvider) ->
  $routeProvider.when '/controller/:controllerId',
      templateUrl: 'controller.html',
      controller: 'ControllerController'
  $routeProvider.when '/controller/:controllerId/sensor/:sensorId',
    templateUrl: 'controller.html',
    controller: 'ControllerController'
  $locationProvider.html5Mode(false)

osp.controller "ControllersController", ($scope, $http, $route, $routeParams, $location) ->
  $scope.controllers = []
  $http.get('http://zeitl.com/api/controllers').success (data) -> $scope.controllers = data
  $scope.isSelected = (controller) -> osp.currentControllerId is controller.id

osp.controller "ControllerController", ($scope, $http, $routeParams) ->
  osp.currentControllerId = $routeParams.controllerId
  $scope.lastTickTime = (sensor) -> moment(sensor.last_tick).format("DD.MM.YYYY HH:mm")
  $http.get('http://zeitl.com/api/controllers/' + $routeParams.controllerId + '/sensors').success (data) -> $scope.sensors = data
  $http.get('http://zeitl.com/api/controllers/' + $routeParams.controllerId).success (data) -> $scope.controller = data
  $scope.$watch 'ticks', -> ospMap.drawMap $scope.ticks
  if $routeParams.sensorId
    $http.get('http://zeitl.com/api/sensors/' + $routeParams.sensorId + '/ticks').success (data) -> $scope.ticks = data.ticks
  else
    $scope.ticks = []
