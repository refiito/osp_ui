# Set up router
osp_map = angular.module 'osp_map', ->

osp_map.controller "MainController", ($scope, $http) ->
  $http.get('http://zeitl.com/api/controllers').success (data) -> $scope.controllers = data

  $scope.selectController = (controller) ->
    console.log 'selectController', controller
    $scope.selectedController = controller
    $http.get('http://zeitl.com/api/controllers/' + $scope.selectedController.id + '/sensors').success (data) -> $scope.drawMarkers(data)

  $scope.lastTickTime = (sensor) -> moment(sensor.last_tick).format("DD.MM.YYYY HH:mm")

  $scope.drawMarkers = (data) ->
    #$scope.ticks = paginated.ticks
    #ospMap.drawMap $scope.ticks
    true
