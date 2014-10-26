ct.directive 'cNavigation', [() ->

  cNavigation =
    replace: true
    templateUrl: 'directives.navigation'
    require: '^cBodyManager'
    link: ($scope, $element, $attrs, $controller) ->

]
