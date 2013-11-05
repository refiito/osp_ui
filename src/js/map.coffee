window.ospGMap = {}
window.ospGMap.map = null

window.ospGMap.placeMarker = (event) ->
  marker = new google.maps.Marker(
    position: event.LatLng,
    map: window.ospGMap.map
  )

initialize = () ->
  mapOptions =
    zoom: 8,
    center: new google.maps.LatLng(-34.397, 150.644),
    mapTypeId: google.maps.MapTypeId.ROADMAP

  window.ospGMap.map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions)
  google.maps.event.addListener(window.ospGMap.map, 'click', window.ospGMap.placeMarker)

google.maps.event.addDomListener(window, 'load', initialize)