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
		min: 'auto',
		series: [
			data: data,
			color: "#c05020"
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
		ticks: 5,
		pixelsPerTick: 150,
		tickFormat: format,
		width: 750
	)

	yelm = document.querySelector(container + ' .y_axis')
	yelm.innerHTML = ""

	y_ticks = new Rickshaw.Graph.Axis.Y(
		graph: chart,
		orientation: 'left',
		pixelsPerTick: 20,
		tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
		element: yelm,
	)

	chart.render()


ospMap.drawMap = (data, done) ->
	labels = []
	temp = []
	hue = []
	battery = []
	signal = []

	_.each(data.reverse().slice(0, 599), (model, idx) ->
		labels.push(moment(model.datetime).format("DD.MM.YYYY"))
		temp.push({x: idx, y: parseFloat(model.temperature)})
		hue.push({x: (idx + 1), y: parseFloat(model.sensor2)})
		battery.push({x: (idx + 1), y: parseFloat(model.battery_voltage_visual)})
		signal.push({x: (idx + 1), y: parseInt(model.radio_quality)})
	)

	ospMap.putData(labels, temp, '#temp', ospMap.tempChart)
	ospMap.putData(labels, hue, '#hue', ospMap.hueChart)
	ospMap.putData(labels, battery, '#battery', ospMap.batChart)
	ospMap.putData(labels, signal, '#signal', ospMap.sigChart)

	if done?
		done()

	true
