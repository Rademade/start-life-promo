app.controller 'newsCategoriesController', [
  'linkOpener', 'synchronization', 'newsService',
  (linkOpener, synchronization, newsService) ->

    INDENT = 36

    @categoriesArrowUp = no
    @subCategoriesArrowUp = no
    @showAllCategories = no
    @showAllSubCategories = no
    @newsService = newsService

    @config =
      onSort : ->
        newsService.getSites().then (sites) =>
          synchronization.setNewsSites(sites)

    @open = (link) ->
      linkOpener.open(link)

    @getOuterWidth = (e) ->
      e.offsetWidth + INDENT

    @allCategories = ->
      @categoriesArrowUp = !@categoriesArrowUp
      @showAllCategories = !@showAllCategories

    @allSubCategories = ->
      @subCategoriesArrowUp = !@subCategoriesArrowUp
      @showAllSubCategories = !@showAllSubCategories

    @turnOffCategoriesArrow = ->
      @allCategories() if @showAllCategories

    @turnOffSubCategoriesArrow = ->
      @allSubCategories() if @showAllSubCategories

    @isArrowVisible = ->
      categoriesContainer = document.querySelector('.tabs.mod-content')
      categoriesItems = document.querySelectorAll('[data-category-item]')
      containerWidth = categoriesContainer.offsetWidth
      widthItems = _.sum _.map(categoriesItems, (e) => @getOuterWidth(e))
      containerWidth <= widthItems

    @isSubArrowVisible = ->
      subCategoriesContainer = document.querySelectorAll('.tabs-data')[2]
      subCategoriesItems = document.querySelectorAll('[data-sub-category-item]')
      containerWidth = subCategoriesContainer.offsetWidth
      widthItems = _.sum _.map(subCategoriesItems, (e) => @getOuterWidth(e))
      containerWidth <= widthItems

    return

]
