# Get the context of the canvas element we want to select
###
ctx = document.getElementById("lines").getContext("2d")

data =
	labels : ["January","February","March","April","May","June","July"]
	datasets : [
		{
			fillColor : "rgba(220,220,220,0.5)",
			strokeColor : "rgba(220,220,220,1)",
			pointColor : "rgba(220,220,220,1)",
			pointStrokeColor : "#fff",
			data : [65,59,90,81,56,55,40]
		},
		{
			fillColor : "rgba(151,187,205,0.5)",
			strokeColor : "rgba(151,187,205,1)",
			pointColor : "rgba(151,187,205,1)",
			pointStrokeColor : "#fff",
			data : [28,48,40,19,96,27,100]
		}
	]

chart = new Chart(ctx).Line(data)
###

osp = angular.module('osp', ['ngRoute']).config(($routeProvider, $locationProvider) ->
	$routeProvider.when('/controller/:controllerId',
    	templateUrl: 'controller.html',
    	controller: 'ControllerCntl'
	)
	$routeProvider.when('/controller/:controllerId/sensor/:sensorId',
		templateUrl: 'sensor.html',
		controller: 'SensorCntl'
	)
 
 	# configure html5 to get links working on jsfiddle
	$locationProvider.html5Mode(false)
)

osp.controller("ControllersCntl", ($scope, $http, $route, $routeParams, $location) ->
	$scope.controllers = []

	$scope.$route = $route
	$scope.$location = $location
	$scope.$routeParams = $routeParams

	$http({method: 'GET', url: 'http://zeitl.com/api/controllers'}).
  	success((data, status, headers, config) ->
  			$scope.controllers = data
  	).
  	error((data, status, headers, config) ->
  		console.log(data, status)
	)
)

osp.controller("ControllerCntl", ($scope, $routeParams) ->
	$scope.name = "ControllerCntl"
	$scope.params = $routeParams
)

osp.controller("SensorCntl", ($scope, $routeParams) ->
	$scope.name = "SensorCntl"
	$scope.params = $routeParams
)
