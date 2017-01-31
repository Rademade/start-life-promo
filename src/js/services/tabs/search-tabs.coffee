app.service 'searchTabService', [
  'TabService', '$localStorage',
  (TabService, $localStorage) ->

    class SearchTabService extends TabService

      @isAllTabsShowed = no
      @isAllTabsShowedBeforeDrug = no

      TABS = [
        {
          name : 'Google', class : 'mod-google', domain : 'google.com',
          searchMod : 'search?q=', provider : 'google', active : yes,
          activeIcon : no, autocomplete : no, replaceSpaces : no
        },
        {
          name : 'YouTube', class : 'mod-youtube', domain : 'youtube.com',
          searchMod : 'results?search_query=', provider : 'youtube', active : no,
          activeIcon : no, autocomplete : no, replaceSpaces : no
        },
        {
          name : 'Maps Google', class : 'mod-google-maps', domain : 'google.com/maps',
          searchMod : '?q=', provider : 'google-maps', active : no,
          activeIcon : no, autocomplete : no, replaceSpaces : no
        },
        {
          name : 'Сraigslist', class : 'mod-craig', domain : 'craigslist.org',
          searchMod : '/search/sss?query=', provider : no, active : no,
          activeIcon : no, autocomplete : no, replaceSpaces : no
        },
        {
          name : 'Amazon', class : 'mod-amazon', domain : 'amazon.com',
          searchMod : 's/field-keywords=', provider : 'amazon', active : no,
          activeIcon : no, autocomplete : no, replaceSpaces : no
        },
        {
          name : 'Ebay', class : 'mod-ebay', domain : 'ebay.com',
          searchMod : 'sch/i.html?_nkw=', provider : 'ebay', active : no,
          activeIcon : no, autocomplete : no, replaceSpaces : no
        },
        {
          name : 'IMDb', class : 'mod-imbd', domain : 'imdb.com',
          searchMod : 'find?q=', provider : 'imdb', active : no,
          activeIcon : no, autocomplete : no, replaceSpaces : yes
        },
        {
          name : 'ESPN', class : 'mod-espn', domain : 'espn.go.com',
          searchMod : 'search/results?q=', provider : 'espn', active : no,
          activeIcon : no, autocomplete : no, replaceSpaces : no
        },
        {
          name : 'Wikipedia', class : 'mod-wikipedia', domain : 'wikipedia.com',
          searchMod : 'w/index.php?search=', provider : 'wikipedia', active : no,
          activeIcon : no, autocomplete : no, replaceSpaces : yes
        },
        {
          name : 'Yahoo', class : 'mod-y', domain : 'search.yahoo.com',
          searchMod : 'search?p=', provider : 'yahoo', active : no,
          activeIcon : no, autocomplete : no, replaceSpaces : no
        },
        {
          name : 'Bing', class : 'mod-bing', domain : 'bing.com',
          searchMod : 'search?q=', provider : 'bing', active : no,
          activeIcon : no, autocomplete : no, replaceSpaces : no
        },
        {
          name : 'Maps Bing', class : 'mod-bing-maps', domain : 'bing.com',
          searchMod : '/maps/default.aspx?q=', provider : 'bing-maps', active : no,
          activeIcon : no, autocomplete : no, replaceSpaces : no
        },
        {
          name : 'Google Play', class : 'mod-google-play', domain : 'play.google.com',
          searchMod : 'store/search?q=', provider : 'google-play', active : no,
          activeIcon : no, autocomplete : no, replaceSpaces : no
        }
      ]

      constructor : () ->
        @tabs = TABS
        @key = 'searchTabs'
        @text = ''
        super

      getTabs : ->
        if @configured
          tabs = $localStorage[@key]
          unless @isInited
            tabs = @setFirstTabActive(tabs)
            @isInited = yes
          tabs
        else
          $localStorage[@key + 'Configured'] = yes
          $localStorage[@key] = @tabs

      setFirstTabActive : (tabs) ->
        _.each tabs, (tab, index) ->
          tab.active = index is 0
          yes
        tabs

      setText : (text) ->
        text = _.trim(text)
        @text = text if text isnt ''

      getText : ->
        @text

      resetIcons : ->
        _.each @getTabs(), (tab) ->
          tab.activeIcon = tab.active
          yes

      getCurrentTab : ->
        _.find @getTabs(), (tab) -> tab.active

      setCurrentTab : (newCurrentTab) ->
        _.each @getTabs(), (tab) ->
          tab.active = tab is newCurrentTab
          yes

      toggleTabs : ->
        @isAllTabsShowed = !@isAllTabsShowed

      allTabsShowed : ->
        @isAllTabsShowed

      closeTabs : ->
        @isAllTabsShowed = no

      setTabsShowedBeforeDrug : ->
        @isAllTabsShowedBeforeDrug = @isAllTabsShowed

      getDomains : ->
        _.map @getTabs(), (tab) -> tab.domain

      toggleIcon : (tab) ->
        tab.activeIcon = !tab.activeIcon if tab

      getActiveIcons : ->
        icons = _.filter @getTabs(), (tab) -> tab.activeIcon
        if icons.length then icons else [@getCurrentTab()]

      isSearchClear : ->
        @getText().length is 0

      open : (item, key) ->
        text = @getText()
        items = @getActiveIcons()

        switch key
          when MODES.OPEN_ICON
            linkOpener.search(text, [item])
          when MODES.OPEN_IN_NEW_TAB
            linkOpener.linkInNewTab(item.domain)
            @resetIcons()
          when MODES.ICON
            @toggleIcon(item)
            @search()

      search : (text) ->
        success = no
        text = text || @getText()
        items = @getActiveIcons()
        if text
          linkOpener.search(text, items)
          requestService.save(text, items)
          @resetIcons()
          success = yes
        success

    new SearchTabService()

]
