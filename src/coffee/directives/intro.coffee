ct.directive 'cIntro', ['$timeout', ($timeout) ->

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
          body_manager.open()

      $timeout increment, 300
      $timeout increment, 800
      $timeout increment, 2000

]
