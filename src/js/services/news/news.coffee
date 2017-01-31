app.service 'newsService', [ 'Site', '$localStorage', '$q', '$sessionStorage', 'NewsCategory', (Site, $localStorage, $q, $sessionStorage, NewsCategory) ->

  key = 'news'
  configured = $localStorage[key + 'Configured'] || no
  newsPromise = undefined
  site = undefined
  categories = []

  isFirstLoadOver : () ->
    $localStorage[key + 'FirstLoadOver'] || no

  firstLoadOver : () ->
    $localStorage[key + 'FirstLoadOver'] = yes

  isLoading : ->
    !$localStorage[key + 'Configured'] || yes

  getNewsSites : () ->
    defer = $q.defer()
    if configured
      defer.resolve($localStorage[key])
    else
      Site.getAll().then (sites) =>
        sites = @serialize(sites)
        $localStorage[key] = sites
        $localStorage[key + 'Configured'] = yes
        configured = yes
        defer.resolve(sites)
    defer.promise

  getSites : ->
    defer = $q.defer()
    defer.resolve($localStorage[key])
    defer.promise

  setSites : (sites = []) ->
    if sites.length
      $localStorage[key] = sites

  setSite : (newSite) ->
    site = newSite
    @setCurrentSite(site)
    NewsCategory.categories(site.id).then (categories) =>
      @setCategories(categories)
      @setCategory(_.first categories)

  setCategory : (newCategory) ->
    newCategory = @getCurrentCategory() if @getCurrentCategory()?
    _.each categories, (category) ->
      category.active = category.id is newCategory.id
      yes

  setSubCategory : (newSubCategory) ->
    newSubCategory = @getCurrentSubCategory() if @getCurrentSubCategory()?
    subCategories = @getSubCategories()
    _.each subCategories, (subCategory) ->
      subCategory.active = subCategory.id is newSubCategory.id
      yes

  getCurrentSite : () ->
    $sessionStorage.currentSite

  setCurrentSite : (site) ->
    $sessionStorage.currentSite = site

  getCurrentCategory : () ->
    $sessionStorage.currentCategory

  setCurrentCategory : (category) ->
    $sessionStorage.currentCategory = category

  getCurrentSubCategory : () ->
    $sessionStorage.currentSubCategory

  setCurrentSubCategory : (subCategory) ->
    $sessionStorage.currentSubCategory = subCategory

  getSite : () ->
    site

  setCategories : (newCategories) ->
    categories = newCategories

  getCategories : () ->
    categories

  getSubCategories : () ->
    @getCategory()?.subCategories

  isSubCategories : () ->
    @getSubCategories()?.length > 0

  getCategory : () ->
    _.find(categories, 'active')

  getSubCategory : () ->
    subCategories = @getSubCategories()
    _.find(subCategories, 'active')

  serialize : (sites) ->
    _.each sites, (site, index) ->
      site.active = index is 0
      _.each site.categories, (category, index) ->
        category.active = index is 0
        yes
      yes

  archive : (id) ->
    @getSites().then (sites) =>
      _.each sites, (site) =>
        if site.id is id
          site.default = no
        yes
      $localStorage[key] = sites

  unarchive : (id) ->
    @getSites().then (sites) =>
      _.each sites, (site) =>
        if site.id is id
          site.position = @getMaxPosition(sites)
          site.default = yes
          site.active = yes
          @setSite(site)
        else
          site.active = no
        yes
      $localStorage[key] = sites

  setActiveSite : (newSite) ->
    @getSites().then (sites) ->
      _.each sites, (site) ->
        site.active = site.name is newSite.name
        yes
      $localStorage[key] = sites

  getMaxPosition : (sites) ->
    return _.maxBy(sites, 'position').position + 1

]
