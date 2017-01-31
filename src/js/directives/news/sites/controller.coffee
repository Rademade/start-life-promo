app.controller 'newsSitesController', [
  '$scope', 'newsService', 'Selector', 'synchronization', 'linkOpener', '$element', '$timeout', '$rootScope', '$stateParams', '$state', '$filter',
  ($scope, newsService, Selector, synchronization, linkOpener, $element, $timeout, $rootScope, $stateParams, $state, $filter) ->

    ESC_KEY_CODE = 27
    ARROW_KEYCODE_UP = 38
    ARROW_KEYCODE_DOWN = 40
    ENTER_CODE = 13

    @isSelectorShowed = no
    @unarchived = []
    @archived = []
    @archivedSorted = []
    @currentId = null

    @selector = new Selector()

    @refreshNews = ->
      $scope.needRefresh = yes
      yes

    @config =
      onSort : (e) =>
        sites = _.concat e.models, @archived
        sites = @setPositions(sites)
        synchronization.setNewsSites(sites)
        newsService.setSites(sites)

    newsService.getNewsSites().then (sites) =>
      return unless sites
      @sort(sites)
      @selector.setValues(@archived)
      synchronization.setNewsSites(sites) if @selector.values.length
      @setSortedArray() if @archivedSorted.length is 0
      currentSite = @selectCurrentSite()
      @setSite(currentSite)
      id = currentSite.id
      $state.go('public.news.show', { 'site_id' : id })

    @selectCurrentSite = ->
      if newsService.getCurrentSite()? then newsService.getCurrentSite() else _.first @unarchived

    @updateSelector = ->
      newsService.getNewsSites().then (sites) =>
        synchronization.setNewsSites(sites) if @selector.values.length
        @sort(sites)
        @selector.setValues(@archived)
        @setSortedArray() if @archivedSorted.length is 0

    @setSite = (site) ->
      newsService.setSite(site)

    @archive = (site) ->
      if site
        newsService.archive(site.id)
        @updateSelector()

    @mouseover = () ->
      @currentId = null

    @unarchive = (site) ->
      if site
        newsService.unarchive(site.id)
        @updateSelector()

    @archivedSitesExist = ->
      @archived.length > 0

    @showSelector = ->
      @isSelectorShowed = yes
      @updateFocus()

    @updateFocus = () ->
      e = $element[0].querySelector('input')
      $timeout(=>
        e.focus()
      , 0)

    @hideSelector = ->
      site = @selector.getSelected()
      newsService.setCurrentSite(site)
      @unarchive(site)
      @isSelectorShowed = no
      $state.go('public.news.show', { 'site_id' : site.id })

    @sort = (sites) ->
      sites = @orderByPositions(sites)
      @unarchived = []
      @archived = []
      _.each sites, (site) =>
        if site.default is yes
          @unarchived.push(site)
        else
          @archived.push(site)
        yes

    @setSortedArray = () ->
      sites = $filter('orderBy')(@archived, 'name')
      regex = new RegExp('^', 'i')
      @archivedSorted = $filter('regex')(sites, 'name', regex)

    @openSite = (site) ->
      linkOpener.open(site.link)

    @setPositions = (sites) ->
      _.each sites, (site, index) ->
        site.position = index + 1

    @orderByPositions = (sites) ->
      _.sortBy sites, 'position'

    window.addEventListener 'keyup', (event) =>
      if event.keyCode is ESC_KEY_CODE
        $rootScope.safeApply () =>
          @isSelectorShowed = no
      if @isSelectorShowed
        currentSite = _.find @archivedSorted, 'id' : @currentId
        sortedIndex = _.indexOf @archivedSorted, currentSite
        @keyDownPressed(currentSite, sortedIndex) if event.keyCode is ARROW_KEYCODE_DOWN
        @keyUpPressed(currentSite, sortedIndex) if event.keyCode is ARROW_KEYCODE_UP
        @enterPressed(currentSite) if event.keyCode is ENTER_CODE

    @changeCurrentId = (sites) ->
      @archivedSorted = sites

    @keyDownPressed = (currentSite, sortedIndex) ->
      lastIndex = @archivedSorted.length - 1
      if currentSite && sortedIndex < lastIndex
        @currentId = @archivedSorted[sortedIndex+1].id
      else
        @currentId = @archivedSorted[0].id
      @updateSelector()

    @keyUpPressed = (currentSite, sortedIndex) ->
      if currentSite && sortedIndex isnt 0
        @currentId = @archivedSorted[sortedIndex-1].id
      else
        last = _.last @archivedSorted
        @currentId = last.id
      @updateSelector()

    @enterPressed = (currentSite) ->
      return unless currentSite
      @selector.setSelected(currentSite)
      @hideSelector()

    return
]
