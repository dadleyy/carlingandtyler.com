ct.directive 'cBodyManager', [() ->

  class BodyManager

    constructor: (@scope, @element) ->

    open: () ->
      @element.addClass 'open'

  BodyManager.$inject = ['$scope', '$element']

  cBodyManager =
    replace: false
    template: false
    controller: BodyManager
    link: ($scope, $element, $attrs) ->

]
