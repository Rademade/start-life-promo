app.factory 'Autocomplete', [
  'StartLifeResource', 'RequestCache',
  (StartLifeResource, RequestCache) ->

    class Autocomplete extends StartLifeResource
      @configure url : '/search/autocomplete', name : 'search_autocomplete'

      put : (params) ->
        Autocomplete.$put @$url(''), params

]
