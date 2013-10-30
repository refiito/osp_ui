window.ospMap = {}

ospMap.drawMap = (data) ->
	battery = _.map(data, (model) ->
		model.battery_voltage
	)
	labels = _.map(data, (model) ->
		""
	)

	ctx = document.getElementById("lines").getContext("2d")

	data =
		labels : labels
		datasets : [
			{
				fillColor : "rgba(220,220,220,0.5)",
				strokeColor : "rgba(220,220,220,1)",
				pointColor : "rgba(220,220,220,1)",
				pointStrokeColor : "#fff",
				data : battery,
				scaleShowLabels: false,
				pointDot: false
			}
		]

	chart = new Chart(ctx).Line(data)