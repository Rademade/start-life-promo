app.factory 'BookmarkCategory', [ 'StartLifeResource', 'RequestCache', (StartLifeResource, RequestCache) ->

  class BookmarkCategory extends StartLifeResource
    @configure url : '/bookmark_categories', name : 'bookmark_categories'

    @getAll : ->
      @requestCache ||= new RequestCache(this)
      @requestCache.getData()

]
