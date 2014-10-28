ct.config ['$routeProvider', ($routeProvider) ->

  introRoute =
    templateUrl: 'views.intro'
    name: 'intro'

  $routeProvider.when '/', introRoute

]
