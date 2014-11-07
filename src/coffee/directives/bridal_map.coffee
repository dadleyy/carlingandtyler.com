ct.directive 'cBridalMap', ['GOOGLE', '$timeout', (GOOGLE, $timeout) ->
  
  map_style = GOOGLE.map_style

  position = new google.maps.LatLng 43.668069, -72.926049

  map_config =
    center: position
    zoom: 8
    mapTypeId: google.maps.MapTypeId.ROADMAP
    styles: map_style
    disableDefaultUI: true

  cBridalMap =
    replace: true
    templateUrl: 'directives.bridal_map'
    link: ($scope, $element, $attrs) ->
      content_el = $element[0].childNodes[2]

      $scope.hovering = false
      $scope.pulled = false

      map = new google.maps.Map content_el, map_config

      marker = new google.maps.Marker
        position: position
        map: map
        icon: '/images/marker.svg'

      resize = () ->
        google.maps.event.trigger map, 'resize'

      $scope.enter = () ->
        $timeout resize, 400

      $scope.leave = () ->
        $timeout resize, 400

      $scope.pulldown = () ->
        $scope.pulled = !$scope.pulled

      google.maps.event.addListener marker, 'mouseover', resize
      google.maps.event.addListener marker, 'mouseout', resize

]
