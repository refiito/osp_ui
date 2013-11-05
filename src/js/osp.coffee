osp = angular.module 'osp', ->

host = 'http://zeitl.com'
#host = 'http://localhost:8084'

kPageSize=100

osp.controller "MainController", ($scope, $http) ->
  $http.get(host + '/api/controllers').success (data) ->
    $scope.controllers = data
    $scope.selectController(if $scope.controllers.length > 0 then $scope.controllers[0] else null)

  $scope.range = 'Month'
  $scope.chartView = true
  $scope.ticks = []
  $scope.page = 1

  $scope.selectController = (controller) ->
    $scope.selectedController = controller
    $http.get(host + '/api/controllers/' + $scope.selectedController.id + '/sensors').success (data) ->
      $scope.sensors = data
      $scope.selectSensor(if $scope.sensors.length > 0 then $scope.sensors[0] else null)

  $scope.loadTicks = ->
    $http.get(host + '/api/sensors/' + $scope.selectedSensor.id + '/ticks?range=' + $scope.range).success (data) ->
      $scope.paginatedTicks = data.ticks.slice(0 * $scope.page, (kPageSize-1) * $scope.page)
      $scope.pages = data.ticks.length / kPageSize
      setTimeout(->
        ospMap.drawMap data.ticks, $scope.range
      , 0)

  $scope.selectSensor = (sensor) ->
    $scope.selectedSensor = sensor
    $scope.loadTicks()

  $scope.selectRange = (range) ->
    $scope.range = range
    $scope.loadTicks()

  $scope.saveControllerName = (controller) ->
    $http.put(host + '/api/controllers/' + $scope.selectedController.id, $scope.selectedController)

osp.filter 'human_date', -> (value) -> moment(value).format("DD.MM.YYYY HH:mm")
osp.filter 'unnamed', -> (value) ->  if value then value else '(unnamed)'
