ct.config ['$routeProvider', ($routeProvider) ->

  menuRoute =
    templateUrl: 'views.menu'
    controller: 'MenuController'
    name: 'menu'
    resolve:
      analytics: ['Analytics', (Analytics) ->
        Analytics.track '/menu'
      ]

  $routeProvider.when '/menu', menuRoute

]
