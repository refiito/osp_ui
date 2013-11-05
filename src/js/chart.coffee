window.ospMap = {}

ospMap.putData = (labels, data, canvas) ->
	data =
		labels : labels
		datasets : [
			{
				fillColor : "rgba(220,220,220,0.5)",
				strokeColor : "rgba(220,220,220,1)",
				pointColor : "rgba(220,220,220,1)",
				pointStrokeColor : "#fff",
				data : data,
				scaleShowLabels: false,
				pointDot: false,
				animation: false
			}
		]

	chart = new Chart(document.getElementById(canvas).getContext("2d")).Line(data)
	

ospMap.drawMap = (data) ->
	labels = _.map(data, (model) ->
		""
	)

	#temp
	temp = _.map(data, (model) ->
		model.temperature
	)
	ospMap.putData(labels, temp, 'temp')

	#hue
	hue = _.map(data, (model) ->
		model.sensor2
	)
	ospMap.putData(labels, hue, 'hue')

	#battery

	battery = _.map(data, (model) ->
		model.battery_voltage_visual
	)
	ospMap.putData(labels, battery, 'battery')
	
	#signal
	signal = _.map(data, (model) ->
		parseInt(model.radio_quality)
	)
	ospMap.putData(labels, signal, 'signal')

	