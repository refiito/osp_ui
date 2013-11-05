# Set up router
osp = angular.module 'osp', ->

osp.controller "MainController", ($scope, $http) ->
  $http.get('http://zeitl.com/api/controllers').success (data) -> $scope.controllers = data

  $scope.range = 'Month'

  $scope.selectController = (controller) ->
    $scope.selectedController = controller
    $http.get('http://zeitl.com/api/controllers/' + $scope.selectedController.id + '/sensors').success (data) -> $scope.sensors = data

  $scope.loadTicks = ->
    console.log 'loadTicks'
    $http.get('http://zeitl.com/api/sensors/' + $scope.selectedSensor.id + '/ticks?range=' + $scope.range).success (data) ->
      $scope.ticks = data.ticks
      ospMap.drawMap $scope.ticks

  $scope.selectSensor = (sensor) ->
    $scope.selectedSensor = sensor
    $scope.loadTicks()

  $scope.selectRange = (range) ->
    $scope.range = range
    $scope.loadTicks()

  $scope.lastTickTime = (sensor) -> moment(sensor.last_tick).format("DD.MM.YYYY HH:mm")

