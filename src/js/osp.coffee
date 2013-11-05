# Set up router
osp = angular.module 'osp', ->

osp.controller "MainController", ($scope, $http) ->
  $http.get('http://zeitl.com/api/controllers').success (data) -> $scope.controllers = data

  $scope.selectController = (controller) ->
    console.log 'selectController', controller
    $scope.selectedController = controller
    $http.get('http://zeitl.com/api/controllers/' + $scope.selectedController.id + '/sensors').success (data) -> $scope.sensors = data

  $scope.selectSensor = (sensor) ->
    console.log 'selectSensor', sensor
    $scope.selectedSensor = sensor
    $http.get('http://zeitl.com/api/sensors/' + $scope.selectedSensor.id + '/ticks').success (data) -> $scope.setTicks(data)
    
  $scope.setTicks = (paginated) ->
    console.log 'setTicks', paginated
    $scope.ticks = paginated.ticks
    ospMap.drawMap $scope.ticks

  $scope.lastTickTime = (sensor) -> moment(sensor.last_tick).format("DD.MM.YYYY HH:mm")
