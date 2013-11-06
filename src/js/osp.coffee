osp = angular.module 'osp', ->

host = 'http://zeitl.com'
#host = 'http://localhost:8084'

kPageSize = 20

osp.controller "MainController", ($scope, $http) ->
  $http.get(host + '/api/controllers').success (data) ->
    $scope.controllers = data
    $scope.selectController(if $scope.controllers.length > 0 then $scope.controllers[0] else null)

  $scope.range = 'Month'
  $scope.chartView = true
  $scope.ticks = []
  $scope.page = 1
  $scope.pages = 1
  $scope.chartStart = moment().subtract(1, 'month')
  $scope.chartEnd = moment()
  $scope.dotsPerDay = 12

  $scope.getUnitForRage = ->
    if $scope.range == 'Biweek'
      'Week'
    else if $scope.range == 'Quarter'
      'Month'
    else
      $scope.range

  $scope.correctAmount = (amount) ->
    if $scope.range == 'Biweek'
      amount * 2
    else if $scope.range == 'Quarter'
      amount * 3
    else
      amount

  $scope.slideRange = (amount) ->
    $scope.chartStart.add($scope.correctAmount(amount), $scope.getUnitForRage())
    $scope.chartEnd.add($scope.correctAmount(amount), $scope.getUnitForRage())
    $scope.loadTicks()

  $scope.selectController = (controller) ->
    $scope.selectedController = controller
    $http.get(host + '/api/controllers/' + $scope.selectedController.id + '/sensors').success (data) ->
      $scope.sensors = data
      $scope.selectSensor(if $scope.sensors.length > 0 then $scope.sensors[0] else null)

  $scope.loadTicks = ->
    $scope.processing = true
    $http.get(host + '/api/sensors/' + $scope.selectedSensor.id + '/ticks?range=' + $scope.range).success (data) ->
      $scope.ticks = data.ticks
      $scope.paginatedTicks = data.ticks.slice 0, kPageSize
      $scope.pages = Math.floor data.ticks.length / kPageSize
      $scope.pages += 1 if data.ticks.length % kPageSize
      $scope.page = 1
      setTimeout(->
        ospMap.drawMap data.ticks, () ->
          $scope.$apply(()->
            $scope.processing = false
          )
      , 0)

  $scope.selectSensor = (sensor) ->
    $scope.selectedSensor = sensor
    $scope.loadTicks()

  $scope.selectRange = (range) ->
    $scope.range = range
    $scope.chartStart = moment($scope.chartEnd).subtract($scope.correctAmount(1), $scope.getUnitForRage())
    switch $scope.range
      when 'Year' then $scope.dotsPerDay = 1
      when 'Quarter' then $scope.dotsPerDay = 4
      when 'Month' then $scope.dotsPerDay = 12
      when 'Biweek' then $scope.dotsPerDay = 24
      else $scope.dotsPerDay = null
    $scope.loadTicks()

  $scope.saveControllerName = (controller) ->
    $http.put(host + '/api/controllers/' + $scope.selectedController.id, $scope.selectedController)

  $scope.setPage = (page) ->
    page = 1 if page < 1
    page = $scope.pages if page > $scope.pages
    $scope.page = page
    start = kPageSize*($scope.page-1)
    end = start+kPageSize
    $scope.paginatedTicks = $scope.ticks.slice start, end

osp.filter 'human_date', -> (value) -> moment(value).format("DD.MM.YYYY HH:mm")
osp.filter 'unnamed', -> (value) ->  if value then value else '(unnamed)'
osp.filter 'moment_date', -> (value) -> value.format("DD.MM.YYYY")