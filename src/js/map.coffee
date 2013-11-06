ospGMap = {}
window.ospGMap = ospGMap

ospGMap.map = null

ospGMap.currentSensor = null
ospGMap.saveSensorCallback = null

ospGMap.markers = []

initialize = () ->
  initial_center = new google.maps.LatLng(-25.363882,131.044922)

  mapOptions =
    zoom: 16,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  
  ospGMap.map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
  if(navigator.geolocation) 
    navigator.geolocation.getCurrentPosition((position) ->
      initial_center = new google.maps.LatLng(position.coords.latitude,position.coords.longitude)
      ospGMap.map.setCenter(initial_center)
    , () ->
      ospGMap.map.setCenter(initial_center)
    )
  else
    ospGMap.map.setCenter(initial_center)

  true

ospGMap.placeMarker = (location) ->
  if ospGMap.currentSensor?
    ospGMap.currentSensor.lat = location.lat().toString()
    ospGMap.currentSensor.lng = location.lng().toString()
    marker = new google.maps.Marker(
      position: location,
      map: ospGMap.map
    )
    ospGMap.markers.push(marker)
    if ospGMap.saveSensorCallback?
      ospGMap.saveSensorCallback(ospGMap.currentSensor)
  ospGMap.currentSensor = null

ospGMap.enablePlacement = () ->
  google.maps.event.addListener(ospGMap.map, 'click', (event) ->
    ospGMap.placeMarker(event.latLng)
  )
  true

ospGMap.disablePlacement = () ->
  google.maps.event.clearListeners(ospGMap.map, 'click')
  true

ospGMap.drawMap = (sensors) ->
  ospGMap.clearMarkers()
  _.each(sensors, (sensor) ->
    if sensor.lng? && sensor.lat?
      location = new google.maps.LatLng(parseFloat(sensor.lat),parseFloat(sensor.lng))
      marker = new google.maps.Marker(
        position: location,
        map: ospGMap.map
      )
      ospGMap.markers.push(marker)
  )

ospGMap.clearMarkers = ->
  _.each(ospGMap.markers, (marker) ->
    marker.setMap(null)
  )
  ospGMap.markers = []

google.maps.event.addDomListener(window, 'load', initialize)