app.factory 'NewsCategory', [ 'StartLifeResource', 'RequestCache', (StartLifeResource, RequestCache) ->

  class NewsCategory extends StartLifeResource
    @configure url : '/sites', name : 'categories'

    @getAll : ->
      @requestCache ||= new RequestCache(this)
      @requestCache.getData()

    @categories : (siteId) ->
      NewsCategory.$get @resourceUrl("#{siteId}/categories.json")

    rss : () ->
      NewsCategory.$get NewsCategory.resourceUrl("#{@siteId}/categories/#{@id}/rss.xml")

]
