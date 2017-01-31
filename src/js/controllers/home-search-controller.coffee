app.controller 'homeSearchController', [
  'linkOpener', 'HomeFactory', 'linkGenerator',
  (linkOpener, HomeFactory, linkGenerator) ->

    @factory = new HomeFactory()
    @selectors = @factory.getSelectors()

    @isAdvancedSearchShowed = no
    @isFormSubmitted = no

    @toggleAdvancedSearch = ->
      @isAdvancedSearchShowed = !@isAdvancedSearchShowed

    @open = (site) ->
      @selectors.isFormSubmitted = yes
      params = _.merge @factory.getParams(), site : site
      if @factory.isValid()
        link = linkGenerator.getHomeLink(params)
        linkOpener.open(link, no)

    @openLink = (site) ->
      linkOpener.open(site)

    return

]
