window.ospMap = {}

ospMap.tempChart = null
ospMap.hueChart = null
ospMap.batChart = null
ospMap.sigChart = null

ospMap.putData = (labels, data, container, chart) ->
	return if data.length == 0

	chart = null

	chart = new Rickshaw.Graph(
		element: document.querySelector(container + " .chart"),
		renderer: 'line',
		height: 200,
		width: 600,
		min: 'auto',
		series: [
			{
				data: data,
				color: "#c05020"
			}
		]
	)

	prevShown = null

	format = (n) ->
		time = labels[n]
		format = "HH:mm"
		
		if !prevShown? || (prevShown? && time? && (prevShown.date() > time.date()))
			format = "DD.MM " + format
		prevShown = time
		if time? then time.format(format) else ''

	x_ticks = new Rickshaw.Graph.Axis.X(
		graph: chart,
		orientation: 'bottom',
		element: document.querySelector(container + " .x_axis"),
		pixelsPerTick: 75,
		tickFormat: format
	)

	y_ticks = new Rickshaw.Graph.Axis.Y(
		graph: chart,
		orientation: 'left',
		pixelsPerTick: 25,
		tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
		element: document.querySelector(container + ' .y_axis'),
	)

	chart.render()


ospMap.drawMap = (data) ->
	labels = _.map(data, (model) ->
		moment(model.datetime)
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
