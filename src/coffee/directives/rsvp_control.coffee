ct.directive 'cRsvpControl', ['$http', ($http) ->

  cRsvpControl =
    replace: false
    templateUrl: 'directives.rsvp_control'
    scope: {}
    link: ($scope, $element, $attrs) ->
      $scope.disabled = false

      submit = () ->
        $scope.disabled = true

      $scope.keywatch = (event) ->
        key_code = event.keyCode
        if key_code == 13
          submit()


]
