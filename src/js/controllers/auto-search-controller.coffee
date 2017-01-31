app.controller 'autoSearchController', [
  'AutoFactory', 'linkOpener', 'linkGenerator',
  (AutoFactory, linkOpener, linkGenerator) ->

    @factory = new AutoFactory(yes)

    @isAdvancedSearchShowed = no

    @toggleAdvancedSearch = ->
      @isAdvancedSearchShowed = !@isAdvancedSearchShowed

    @open = (site) ->
      @factory.setFormSubmitted(yes)
      params = _.merge @factory.getBaseParams(), site : site
      if @factory.isParamsValid(params)
        _.each @factory.getCarsParams(), (car) =>
          link = linkGenerator.getAutoLink(_.merge(params, car))
          linkOpener.open(link, no)
        yes

    @openLink = (site) ->
      linkOpener.open(site)

    @factory.addNewCar()

    return

]

