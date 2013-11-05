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
			{
				data: data,
				color: "#c05020"
			}
		]
	)

	format = (n) ->
		ret = labels[n]
		return if ret then ret.format("DD.MM HH:mm") else ''

	xelm = document.querySelector(container + " .x_axis")
	xelm.innerHTML = ""

	x_ticks = new Rickshaw.Graph.Axis.X(
		graph: chart,
		orientation: 'bottom',
		element: xelm,
		pixelsPerTick: 90,
		tickFormat: format
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


ospMap.drawMap = (data, range) ->
	start = moment()
	switch range
		when 'Year' then start.subtract('years', 1)
		when 'Quarter' then start.subtract('months', 3)
		#Month
		else start.subtract('months', 1)

	labels = _.map(data, (model) ->
		moment(model.datetime)
	)

	temp = _.map(data, (model, idx) ->
		{
			x: idx
			y: parseFloat(model.temperature)
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
			y: parseFloat(model.battery_voltage_visual)
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
