# Set up router
osp_map = angular.module('osp_map', ['ngRoute']).config ($routeProvider, $locationProvider) ->
  $routeProvider.when '/controller/:controllerId',
      templateUrl: 'controller.html',
      controller: 'ControllerController'
  $locationProvider.html5Mode(false)

osp_map.controller "ControllersController", ($scope, $http, $route, $routeParams, $location) ->
  $scope.controllers = []
  $http.get('http://zeitl.com/api/controllers').success (data) -> $scope.controllers = data
  $scope.isSelected = (controller) -> osp_map.currentControllerId is controller.id

osp_map.controller "ControllerController", ($scope, $http, $routeParams) ->
  osp_map.currentControllerId = $routeParams.controllerId
  $scope.lastTickTime = (sensor) -> moment(sensor.last_tick).format("DD.MM.YYYY HH:mm")
  $http.get('http://zeitl.com/api/controllers/' + $routeParams.controllerId + '/sensors').success (data) -> $scope.sensors = data
