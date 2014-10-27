ct.directive 'cNavigation', ['$rootScope', ($rootScope) ->

  cNavigation =
    replace: true
    templateUrl: 'directives.navigation'
    require: '^cBodyManager'
    link: ($scope, $element, $attrs, $controller) ->
      $scope.current_location = false

      success = (evt, route_info) ->
        if route_info.$$route
          $scope.current_location = route_info.$$route.name

      $rootScope.$on '$routeChangeSuccess', success

]
