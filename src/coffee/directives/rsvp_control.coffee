ct.directive 'cRsvpControl', ['$http', '$window', 'URLS', ($http, $window, URLS) ->

  cRsvpControl =
    replace: false
    templateUrl: 'directives.rsvp_control'
    scope:
      guests: '='
    link: ($scope, $element, $attrs) ->
      $scope.disabled = false
      $scope.invalid = false
      $scope.error_msg = ''

      local_store = $window.localStorage

      if local_store
        stored_val = localStorage.getItem 'rsvpd'
        has_saved = stored_val == 'yes'
      else
        has_saved = false

      $scope.saved = has_saved
      $scope.guest = {}

      api_route = [URLS.api, 'rsvp'].join '/'

      submit = () ->
        $scope.disabled = true
        email_addr = $scope.guest.email
        valid = /([\w\.\-_]+)?\w+@[\w\-\_]+(\.\w+){1,}/.test email_addr

        if !valid
          $scope.disabled = false
          $scope.invalid = true
          $scope.error_msg = 'please enter a valid email'
        else
          save(email_addr)

      finish = (response) ->
        $window.localStorage.setItem 'rsvpd', 'yes'
        $scope.saved = true
        $scope.guests.push response.data

      fail = () ->
        $scope.error_msg = 'couldn\'t save ya, maybe you already RSVPd?'
        $scope.invalid = true
        $scope.disabled = false

      save = (addr) ->
        promise = $http.post api_route,
          email: addr
        promise.then finish, fail

      $scope.keywatch = (event) ->
        $scope.invalid = false
        key_code = event.keyCode
        if key_code == 13
          submit()


]
