ct.config ['$routeProvider', ($routeProvider) ->

  homeRoute =
    templateUrl: 'views.home'
    controller: 'HomeController'
    resolve:
      analytics: ['Analytics', (Analytics) ->
        Analytics.track '/home'
      ]

  $routeProvider.when '/home', homeRoute

]
