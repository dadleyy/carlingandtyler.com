ct = do () ->
  ct = angular.module 'ct', ['ngRoute', 'ngResource']

  loaded_config = (response) ->
    data = response.data
    ct.value 'URLS', data.urls
    ct.value 'GOOGLE', data.google
    ct.value 'BACKGROUND', data.background
    if data.colors
      ct.value 'COLORS', data.colors
    else
      ct.value 'COLORS',
        tracks: {}
        playlists: {}

    if data.soundcloud and data.soundcloud.client_id
      client_id = atob data.soundcloud.client_id
      ct.value 'SOUNDCLOUD_KEY', client_id
      ct.value 'SOUNDCLOUD_USER', data.soundcloud.user_id

    angular.bootstrap document, ['ct']

  failed_config = () ->

  injector = angular.injector ['ng']
  http = injector.get '$http'
  http.get('/app.conf').then loaded_config, failed_config
  ct
