ct.directive 'cFeed', ['Viewport', '$timeout', (Viewport, $timeout) ->

  class FeedController

    constructor: (@scope, @element) ->
      initialized = false
      element = @element[0]
      total_width = 0
      column_width = 0
      column_gutter = 2
      column_count = 3
      column_heights = new Array column_count
      @column_count = [0,0,0]

      @item_ids = new Array @scope.items.length
      @item_ids[indx] = item.id for item, indx in @scope.items

      @scope.styles = new Array @scope.items.length

      itemWidth = (item) ->
        if angular.isArray item.entities.media
          item_media = item.entities.media[0]
          item_media.sizes.medium.w
        else
          0
      
      itemHeight = (item) ->
        if angular.isArray item.entities.media
          item_media = item.entities.media[0]
          item_media.sizes.medium.h
        else
          0

      position = (feed_item, item_index) ->
        lowest_height = Infinity
        target_index = -1
        style =
          position: 'absolute'
          width: [column_width, 'px'].join ''

        for height, index in column_heights
          if height < lowest_height
            lowest_height = height
            target_index = index

        item_width = itemWidth feed_item
        item_height = itemHeight feed_item
        calculated_width = column_width
        overflowing = item_width > (column_width * 1.25)
        not_last_colum = target_index < (column_count - 1)
        okay_to_overlow = not_last_colum && column_heights[target_index+1] <= lowest_height

        if overflowing and okay_to_overlow
          calculated_width = column_width * 2
          style.width = [calculated_width, 'px'].join ''
          scale = calculated_width / item_width
          real_height = item_height * scale
          column_heights[target_index] += (real_height + column_gutter)
          column_heights[target_index+1] += (real_height + column_gutter)
        else
          scale = column_width / item_width
          real_height = item_height * scale
          column_heights[target_index] += (real_height + column_gutter)

        style.height = [real_height, 'px'].join ''
        guttered_width = (target_index + 1) * column_gutter
        style.left = [(target_index * column_width) + guttered_width, 'px'].join ''
        style.top = [lowest_height, 'px'].join ''
        style
        

      initialize = () =>
        initialized = true
        guttered_width = column_gutter * (column_heights.length + 1)
        total_width = @element[0].offsetWidth - guttered_width
        column_width = total_width / column_count
        column_heights[indx] = 0 for c, indx in column_heights
        @scope.styles[indx] = position @scope.items[indx], indx for style, indx in @scope.styles
        @column_heights = column_heights
        initialized

      @scope.$on 'viewswap:complete', initialize

  FeedController.$inject = ['$scope', '$element']

  cFeed =
    restrict: 'EA'
    replace: true
    templateUrl: 'directives.feed'
    controller: FeedController
    scope:
      items: '='
    link: ($scope, $element, $attrs, $controller) ->
      feed_controller = $controller

      $scope.listStyle = () ->
        max_height = Math.max.apply null, feed_controller.column_heights
        style =
          height: [max_height, 'px'].join ''

]
