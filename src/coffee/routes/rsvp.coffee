ct.config ['$routeProvider', ($routeProvider) ->

  rsvpRoute =
    templateUrl: 'views.rsvp'
    controller: 'RsvpController'
    name: 'rsvp'
    resolve:
      analytics: ['Analytics', (Analytics) ->
        Analytics.track '/rsvp'
      ]

  $routeProvider.when '/rsvp', rsvpRoute

]
