ct.directive 'cNavigation', ['$rootScope', '$timeout', '$location', ($rootScope, $timeout, $location) ->

  cNavigation =
    replace: true
    templateUrl: 'directives.navigation'
    require: '^cBodyManager'
    link: ($scope, $element, $attrs, $controller) ->
      $scope.current_location = false
      $scope.open = false
      $scope.cover_block = false

      $scope.toggle = () ->
        $scope.open = !$scope.open

        close = () ->
          $scope.cover_block = false

        if $scope.open
          $scope.cover_block = true
        else
          $timeout close, 500

      $scope.goHome = (event) ->
        $scope.open = false
        $location.url '/'

      success = (evt, route_info) ->
        if route_info.$$route
          $scope.current_location = route_info.$$route.name

      $rootScope.$on '$routeChangeSuccess', success

]
