window.ospMap = {}

ospMap.tempChart = null
ospMap.hueChart = null
ospMap.batChart = null
ospMap.sigChart = null

ospMap.putData = (labels, data, canvas, chart_point) ->
	chart_point = null
	data =
		labels : labels
		datasets : [
			{
				fillColor : "rgba(220,220,220,0.5)",
				strokeColor : "rgba(220,220,220,1)",
				pointColor : "rgba(220,220,220,1)",
				pointStrokeColor : "#fff",
				data : data
			}
		]

	opts =
		pointDot: false,
		animation: false

	chart_point = new Chart(document.getElementById(canvas).getContext("2d")).Line(data, opts)
	

ospMap.drawMap = (data) ->
	labels = _.map(data, (model, idx) ->
		if idx % 10 is 0 then moment(model.datetime).format("HH:mm") else ''
	)

	#temp
	temp = _.map(data, (model) ->
		model.temperature
	)
	ospMap.putData(labels, temp, 'temp', ospMap.tempChart)

	#hue
	hue = _.map(data, (model) ->
		model.sensor2
	)
	ospMap.putData(labels, hue, 'hue', ospMap.hueChart)

	#battery
	battery = _.map(data, (model) ->
		model.battery_voltage_visual
	)
	ospMap.putData(labels, battery, 'battery', ospMap.batChart)
	
	#signal
	signal = _.map(data, (model) ->
		parseInt(model.radio_quality)
	)
	ospMap.putData(labels, signal, 'signal', ospMap.sigChart)

	