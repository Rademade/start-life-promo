app.factory 'Country', [ 'StartLifeResource', 'RequestCache', (StartLifeResource, RequestCache) ->

  class Country extends StartLifeResource
    @configure url : '/countries', name : 'countries'

    @getAll : ->
      @requestCache ||= new RequestCache(this)
      @requestCache.getData()

]
