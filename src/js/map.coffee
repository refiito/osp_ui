ospGMap = {}
window.ospGMap = ospGMap

ospGMap.map = null

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
  marker = new google.maps.Marker(
    position: location,
    map: ospGMap.map
  )

ospGMap.enablePlacement = () ->
  google.maps.event.addListener(ospGMap.map, 'click', (event) ->
    ospGMap.placeMarker(event.latLng)
  )
  true

ospGMap.disablePlacement = () ->
  google.maps.event.clearListeners(map, 'bounds_changed')
  true

google.maps.event.addDomListener(window, 'load', initialize)