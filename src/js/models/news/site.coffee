app.factory 'Site', [ 'StartLifeResource', 'RequestCache', (StartLifeResource, RequestCache) ->

  class Site extends StartLifeResource
    @configure url : '/sites', name : 'sites'

    @getAll : (getterArgs = []) ->
      if getterArgs.size == 0
        @requestCache ||= new RequestCache(this)
        @requestCache.getData()
      else
        @requestCache ||= new RequestCache(this, 'query', getterArgs)
        @requestCache._addFreshData(getterArgs)

]
