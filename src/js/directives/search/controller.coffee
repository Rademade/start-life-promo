app.controller 'searchController', [
  '$rootScope', '$timeout', '$element', 'linkOpener', 'requestService', 'autocomplete', 'searchTabService', 'synchronization', '$scope',
  ($rootScope, $timeout, $element, linkOpener, requestService, autocomplete, searchTabService, synchronization, $scope) ->

    AUTOCOMPLETE_ENABLED = no
    @tabService = searchTabService
    @results = []

    @config =
      onStart : (e) =>
        @tabService.setTabsShowedBeforeDrug()
        @tabService.toggleTabs() unless @tabService.isAllTabsShowed
      onEnd : (e) =>
        @tabService.toggleTabs() unless @tabService.isAllTabsShowedBeforeDrug
      onSort : (e) =>
        tabs = searchTabService.setFirstTabActive(e.models)
        searchTabService.setTabs(tabs)
        synchronization.setSearchSites(tabs)

    @clearInput = () ->
      $scope.$broadcast('angucomplete-alt:clearInput')

    @clearResults = () ->
      @results = []

    @toggleIcon = (icon) ->
      searchTabService.toggleIcon(icon)
      @updateFocus()

    @resetIcons = ->
      searchTabService.resetIcons()

    @updateAutocomplete = ->
      return unless AUTOCOMPLETE_ENABLED
      text = searchTabService.getText()
      tab = searchTabService.getCurrentTab()
      if text.length > 0 && tab.provider
        autocomplete.get(tab.provider, text).then (data) =>
          @results = data

    @setCurrentTab = (tab) ->
      searchTabService.setCurrentTab(tab)
      @resetIcons()
      @updateAutocomplete()
      @updateFocus()
      @clearResults()

    @updateFocus = () ->
      e = @getInputField()
      e.focus() if e

    @getInputField = () ->
      angular.element(document)[0].querySelector('form input')

    @enter = (e) ->
      keyCode = e.keyCode
      text = e.srcElement.value
      searchTabService.setText(text)
      @process(text, keyCode)

    @process = (text, keyCode) ->
      unless window.isRequestPending()
        @updateAutocomplete()
      if keyCode is 13
        @search(text)

    @search = (text) ->
      if text
        searchTabService.setText(text)
        @clearInput()
        icons = searchTabService.getActiveIcons()
        linkOpener.search(text, icons)
        requestService.save(text, icons)
        @resetIcons()
        @updateFocus()
        @clearResults()

    @open = (icon) =>
      searchTabService.toggleIcon(icon)
      linkOpener.search(searchTabService.getText(), searchTabService.getActiveIcons())

    @openIcon = (icon) =>
      linkOpener.search(searchTabService.getText(), [icon])

    @openInTab = (link) ->
      linkOpener.openHere(link)
      @resetIcons()

    @localSearch = (str, items) ->
      items

    @showMakeSingleSearch = () ->
      !searchTabService.getCurrentTab().autocomplete

    searchTabService.closeTabs()
    @resetIcons() if searchTabService.isSearchClear()

    return

]
