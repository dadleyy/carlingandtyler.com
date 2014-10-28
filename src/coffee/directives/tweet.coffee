ct.directive 'cTwit', [() ->

  cTwit =
    replace: true
    templateUrl: 'directives.twit'
    require: '^cFeed'
    scope:
      twit: '='
    link: ($scope, $element, $attr, $controller) ->
      feed_controller = $controller

      $scope.image = () ->
        $scope.twit.entities.media[0].media_url

]
