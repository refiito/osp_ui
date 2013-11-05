osp = angular.module 'osp', ->

host = 'http://zeitl.com'
#host = 'http://localhost:8084'

kPageSize=20

osp.controller "MainController", ($scope, $http) ->
  $http.get(host + '/api/controllers').success (data) ->
    $scope.controllers = data
    $scope.selectController(if $scope.controllers.length > 0 then $scope.controllers[0] else null)

  $scope.range = 'Month'
  $scope.chartView = !true
  $scope.ticks = []
  $scope.page = 1
  $scope.pages = 1

  $scope.selectController = (controller) ->
    $scope.selectedController = controller
    $http.get(host + '/api/controllers/' + $scope.selectedController.id + '/sensors').success (data) ->
      $scope.sensors = data
      $scope.selectSensor(if $scope.sensors.length > 0 then $scope.sensors[0] else null)

  $scope.loadTicks = ->
    $http.get(host + '/api/sensors/' + $scope.selectedSensor.id + '/ticks?range=' + $scope.range).success (data) ->
      $scope.paginatedTicks = data.ticks.slice(0 * $scope.page, (kPageSize-1) * $scope.page)
      $scope.pages = Math.floor data.ticks.length / kPageSize
      $scope.pages += 1 if data.ticks.length % kPageSize
      $scope.page = 1
      setTimeout(->
        ospMap.drawMap data.ticks, $scope.range
      , 0)
      console.log 'data.ticks.length', data.ticks.length
      console.log '$scope.paginatedTicks', $scope.paginatedTicks.length
      console.log '$scope.pages', $scope.pages
      console.log '$scope.page', $scope.page

  $scope.selectSensor = (sensor) ->
    $scope.selectedSensor = sensor
    $scope.loadTicks()

  $scope.selectRange = (range) ->
    $scope.range = range
    $scope.loadTicks()

  $scope.saveControllerName = (controller) ->
    $http.put(host + '/api/controllers/' + $scope.selectedController.id, $scope.selectedController)

  $scope.setPage = (page) ->
    page = 1 if page < 1
    page = $scope.pages if page > $scope.pages
    console.log 'setPage', page
    $scope.page = page

osp.filter 'human_date', -> (value) -> moment(value).format("DD.MM.YYYY HH:mm")
osp.filter 'unnamed', -> (value) ->  if value then value else '(unnamed)'
