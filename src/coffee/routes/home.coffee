ct.config ['$routeProvider', ($routeProvider) ->

  homeRoute =
    templateUrl: 'views.home'
    controller: 'HomeController'
    name: 'location'
    resolve:
      analytics: ['Analytics', (Analytics) ->
        Analytics.track '/location'
      ]

  $routeProvider.when '/location', homeRoute

]
