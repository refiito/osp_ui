# Set up router
osp_map = angular.module 'osp_map', ->

osp_map.controller "MainController", ($scope, $http) ->
  $http.get('http://zeitl.com/api/controllers').success (data) -> $scope.controllers = data

  $scope.selectedSensor = null

  $scope.selectController = (controller) ->
    console.log 'selectController', controller
    $scope.selectedController = controller
    $http.get('http://zeitl.com/api/controllers/' + $scope.selectedController.id + '/sensors').success (data) -> $scope.drawMarkers(data)

  $scope.placeSensor = (sensor) ->
    $scope.selectedSensor = sensor
    ospGMap.enablePlacement()

  $scope.drawMarkers = (data) ->
    $scope.sensors = data
    #$scope.ticks = paginated.ticks
    #ospMap.drawMap $scope.ticks
    true
