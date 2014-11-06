ct.config ['$routeProvider', ($routeProvider) ->

  rsvpRoute =
    templateUrl: 'views.rsvp'
    controller: 'RsvpController'
    name: 'rsvp'
    resolve:
      guests: ['URLS', '$http', '$q', (URLS, $http, $q) ->
        deferred = $q.defer()
        api_url = [URLS.api, 'rsvp'].join '/'

        finish = (response) ->
          guests = response.data
          deferred.resolve guests

        request = $http.get api_url
        request.then finish

        deferred.promise
      ]
      analytics: ['Analytics', (Analytics) ->
        Analytics.track '/rsvp'
      ]

  $routeProvider.when '/rsvp', rsvpRoute

]
