ct.directive 'cBridalMap', ['GOOGLE', (GOOGLE) ->
  
  map_style = GOOGLE.map_style

  position = new google.maps.LatLng 43.668069, -72.926049

  map_config =
    center: position
    zoom: 10
    mapTypeId: google.maps.MapTypeId.ROADMAP
    styles: map_style
    disableDefaultUI: true

  cBridalMap =
    replace: true
    templateUrl: 'directives.bridal_map'
    link: ($scope, $element, $attrs) ->
      map = new google.maps.Map $element[0], map_config
      marker = new google.maps.Marker
        position: position
        map: map

]
