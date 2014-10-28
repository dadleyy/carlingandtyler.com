ct.directive 'cBodyManager', ['$rootScope', ($rootScope) ->

  class BodyManager

    constructor: (@scope, @element) ->

    open: () ->
      @element.addClass 'open'

  BodyManager.$inject = ['$scope', '$element']

  cBodyManager =
    replace: false
    template: false
    controller: BodyManager
    link: ($scope, $element, $attrs, $controller) ->
      update = (evt, route_info) ->
        if route_info.$$route
          is_intro = /intro/i.test route_info.$$route.name
          if !is_intro
            $controller.open()

      $rootScope.$on '$routeChangeStart', update

]
