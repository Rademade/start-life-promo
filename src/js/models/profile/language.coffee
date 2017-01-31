app.factory 'Language', [ 'StartLifeResource', 'RequestCache', (StartLifeResource, RequestCache) ->

  class Language extends StartLifeResource
    @configure url : '/languages', name : 'languages'

    @getAll : ->
      @requestCache ||= new RequestCache(this)
      @requestCache.getData()

]
