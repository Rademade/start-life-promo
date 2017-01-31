app.factory 'Bookmark', [ 'StartLifeResource', 'RequestCache', (StartLifeResource, RequestCache) ->

  class Bookmark extends StartLifeResource
    @configure url : '/bookmarks', name : 'bookmarks'

    @getAll : ->
      @requestCache ||= new RequestCache(this)
      @requestCache.getData()

]
