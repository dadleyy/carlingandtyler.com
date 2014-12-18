ct.directive 'cImageFader', ['$timeout', ($timeout) ->

  IMAGES = [
    "http://static.sizethreestudios.com/images/carling/001.jpg",
    "http://static.sizethreestudios.com/images/carling/002.jpg",
    "http://static.sizethreestudios.com/images/carling/003.jpg"
  ]

  TIME_INTERVAL = 6000

  cImageFader =
    restrict: 'A'
    replace: true
    templateUrl: 'directives.image_fader'
    link: ($scope, $element, $attrs) ->
      $scope.images = IMAGES
      $scope.active_index = 0

      change = () ->
        $scope.active_index++

        if $scope.active_index > IMAGES.length - 1
          $scope.active_index = 0

        $scope.$digest()

        setTimeout change, TIME_INTERVAL
        $scope.active_index

      $scope.style = (index) ->
        image_url = ['url(', IMAGES[index], ')'].join ''

        item_style =
          'background-image': image_url

      setTimeout change, TIME_INTERVAL

]
