ct.config ['$routeProvider', ($routeProvider) ->

  registryRoute =
    templateUrl: 'views.registries'
    controller: 'RegistriesController'
    name: 'registries'
    resolve:
      analytics: ['Analytics', (Analytics) ->
        Analytics.track '/registries'
      ]

  $routeProvider.when '/registries', registryRoute

]
