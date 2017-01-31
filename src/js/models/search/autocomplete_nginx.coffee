app.factory 'AutocompleteNginx', [ 'StartLifeResource', (StartLifeResource) ->

  class AutocompleteNginx extends StartLifeResource
    @configure url : '', name : 'autocomplete', rootWrapping : no

    get : (url, params) ->
      AutocompleteNginx.$get @$url(url), params

]

