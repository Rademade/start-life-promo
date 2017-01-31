app.factory 'Setting', [ 'StartLifeResource', 'RequestCache', (StartLifeResource, RequestCache) ->

  class Setting extends StartLifeResource
    @configure url : '/settings', name : 'settings'

    @getAll : ->
      @requestCache ||= new RequestCache(this)
      @requestCache.getData()

    load : (params) ->
      Setting.$get @$url('load'), params

    sync : (params) ->
      Setting.$put @$url('sync'), params

]
