ct = do () ->
  ct = angular.module 'ct', ['ngRoute', 'ngResource']

  loaded_config = (response) ->
    data = response.data
    ct.value 'URLS', data.urls
    ct.value 'GOOGLE', data.google
    ct.value 'REGISTRIES', data.registries
    ct.value 'TWITTER', data.twitter

    angular.bootstrap document, ['ct']

  failed_config = () ->

  injector = angular.injector ['ng']
  http = injector.get '$http'
  http.get('/app.conf').then loaded_config, failed_config
  ct
