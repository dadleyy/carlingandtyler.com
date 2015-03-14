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

      submit = (is_attending) ->
        $scope.disabled = true
        email_addr = $scope.guest.email
        valid = /([\w\.\-_]+)?\w+@[\w\-\_]+(\.\w+){1,}/.test email_addr

        if !valid
          $scope.disabled = false
          $scope.invalid = true
          $scope.error_msg = 'please enter a valid email'
        else
          save email_addr, is_attending

      finish = (response) ->
        $window.localStorage.setItem 'rsvpd', 'yes'
        $scope.saved = true
        $scope.guests.push response.data

      fail = () ->
        $scope.error_msg = 'couldn\'t save ya, maybe you already RSVPd?'
        $scope.invalid = true
        $scope.disabled = false

      save = (addr, is_attending) ->
        promise = $http.post api_route,
          email: addr
          attending: if is_attending then 1 else 0

        promise.then finish, fail

      $scope.attempt = (attending_flag) ->
        submit attending_flag

      $scope.keywatch = (event) ->
        $scope.invalid = false

]
