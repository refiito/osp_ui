# Set up router
osp_map = angular.module 'osp_map', ->

host = 'http://zeitl.com'

osp_map.controller "MainController", ($scope, $http) ->
  $http.get('http://zeitl.com/api/controllers').success (data) -> $scope.controllers = data

  $scope.selectedSensor = null

  $scope.selectController = (controller) ->
    $scope.selectedController = controller
    $http.get('http://zeitl.com/api/controllers/' + 
      $scope.selectedController.id + '/sensors').success(
        (data) -> $scope.drawMarkers(data)
      )

  $scope.placeSensor = (sensor) ->
    $scope.selectedSensor = sensor
    ospGMap.currentSensor = $scope.selectedSensor
    ospGMap.saveSensorCallback = $scope.saveSensorCallback
    ospGMap.enablePlacement()

  $scope.saveSensorCallback = (sensor) ->
    $http.put(host + '/api/sensors/' + sensor.id, sensor)
    $scope.$apply(()->
      $scope.sensors = _.without($scope.sensors, _.findWhere($scope.sensors, {id: $scope.selectedSensor.id}));
      $scope.selectedSensor = null
    )
    ospGMap.disablePlacement()

  $scope.drawMarkers = (data) ->
    $scope.sensors = _.filter(data, (model) -> !model.lng? && !model.lat?)
    ospGMap.drawMap(_.filter(data, (model) -> model.lng? && model.lat?))
    true
