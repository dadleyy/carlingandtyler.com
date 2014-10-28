ct.config ['$routeProvider', ($routeProvider) ->

  feedRoute =
    templateUrl: 'views.feed'
    controller: 'FeedController'
    name: 'feed'
    resolve:
      tweets: ['$http', '$q', 'URLS', 'TWITTER', ($http, $q, URLS, TWITTER) ->
        deferred = $q.defer()
        search_str = btoa TWITTER.hashtag
        full_url = [URLS.twitter, search_str].join '/'

        success = (response) ->
          if response and response.data and response.data.statuses
            deferred.resolve response.data.statuses
          else
            fail(response)

        fail = () ->
          deferred.reject 'failed'

        promise = $http.get full_url
        promise.then success, fail
        deferred.promise
      ]

  $routeProvider.when '/feed', feedRoute

]
