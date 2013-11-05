window.ospMap = {}

ospMap.tempChart = null
ospMap.hueChart = null
ospMap.batChart = null
ospMap.sigChart = null

ospMap.putData = (labels, data, container, chart) ->
	return if data.length == 0

	chart = null

	elm = document.querySelector(container + " .chart")
	elm.innerHTML = ""

	chart = new Rickshaw.Graph(
		element: elm,
		renderer: 'line',
		height: 200,
		width: 600,
		series: [
			{
				data: data,
				color: "#c05020"
			}
		]
	)

	format = (n) ->
		labels[n]

	xelm = document.querySelector(container + " .x_axis")
	xelm.innerHTML = ""

	x_ticks = new Rickshaw.Graph.Axis.X(
		graph: chart,
		orientation: 'bottom',
		element: xelm,
		pixelsPerTick: 50,
		tickFormat: format
	)

	yelm = document.querySelector(container + ' .y_axis')
	yelm.innerHTML = ""

	y_ticks = new Rickshaw.Graph.Axis.Y(
		graph: chart,
		orientation: 'left',
		pixelsPerTick: 100,
		tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
		element: yelm,
	)

	chart.render()


ospMap.drawMap = (data) ->
	ospMap.tempChart = null

	labels = _.map(data, (model) ->
		moment(model.datetime).format("HH:mm")
	)

	temp = _.map(data, (model, idx) ->
		{
			x: (idx + 1)
			y: model.temperature
		}
	)

	ospMap.putData(labels, temp, '#temp', ospMap.tempChart)

	#hue
	hue = _.map(data, (model, idx) ->
		{
			x: (idx + 1)
			y: parseFloat(model.sensor2)
		}
	)
	ospMap.putData(labels, hue, '#hue', ospMap.hueChart)

	#battery
	battery = _.map(data, (model, idx) ->
		{
			x: (idx + 1)
			y: model.battery_voltage_visual
		}
	)
	ospMap.putData(labels, battery, '#battery', ospMap.batChart)
	
	#signal
	signal = _.map(data, (model, idx) ->
		{
			x: (idx + 1)
			y: parseInt(model.radio_quality)
		}
	)
	ospMap.putData(labels, signal, '#signal', ospMap.sigChart)
