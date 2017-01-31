app.factory 'Request', [ 'StartLifeResource', 'RequestCache', (StartLifeResource, RequestCache) ->

  class Request extends StartLifeResource
    @configure url : '/requests', name : 'requests'

    @getAll : ->
      @requestCache ||= new RequestCache(this)
      @requestCache.getData()

]
