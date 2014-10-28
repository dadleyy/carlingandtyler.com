ct.directive 'cIntro', ['$timeout', '$route', '$location', ($timeout, $route, $location) ->

  cIntro =
    replace: true
    templateUrl: 'directives.intro'
    require: '^cBodyManager'
    link: ($scope, $element, $attrs, $controller) ->
      $scope.stage = 0
      body_manager = $controller

      increment = () ->
        $scope.stage++
        if $scope.stage > 2
          $scope.stage = 2
          body_manager.open()
          $location.url '/location'

      start = () ->
        $timeout increment, 300
        $timeout increment, 800
        $timeout increment, 3000

      start()

]
