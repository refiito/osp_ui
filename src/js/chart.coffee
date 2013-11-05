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
		#ret = labels[n]
		#return if ret? then ret.format("DD.MM.YYYY HH:mm") else ''
		labels[n]

	xelm = document.querySelector(container + " .x_axis")
	xelm.innerHTML = ""

	x_ticks = new Rickshaw.Graph.Axis.X(
		graph: chart,
		orientation: 'bottom',
		element: xelm,
		ticks: 5,
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
	true

ospMap.drawMap = (data, range) ->
	start = moment()
	switch range
		when 'Year' then start.subtract(1, 'year')
		when 'Quarter' then start.subtract(3, 'months')
		#Month
		else start.subtract(1, 'month')

	start = start.startOf('hour').unix()

	labels = []
	temp = []

	step = 86400

	indexed = _.indexBy(data, (m) -> moment(m.datetime).startOf('hour').unix())
	console.log(indexed)

	for i in [0..599] by 1
		x_point = start + (i * step)
		labels.push(x_point)
		#model = _.find(data, (m) -> (moment(m.datetime).unix() > x_point) && (moment(m.datetime).unix() < (x_point + step)))
		model = indexed[x_point]
		y_point = if model? then model.temperature else null
		console.log(y_point)
		temp.push({x: x_point, y: y_point})

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
