app.service 'headerTabService', [
  'TabService', '$localStorage', '$state',
  (TabService, $localStorage, $state) ->

    class HeaderTabService extends TabService

      TABS = [
        { sref : 'index.home', classMod : 'mod-home', name : 'Start', active : yes, inclusionFlag : 'index.home' },
        { sref : 'public.multi-search.travel', classMod : 'mod-search', name : 'Multisearch', active : no, inclusionFlag : 'public.multi-search' },
        { sref : 'public.news', classMod : 'mod-news', name : 'News', active : no, inclusionFlag : 'public.news' }
      ]

      constructor : () ->
        @tabs = TABS
        @key = 'headerTabs'
        super

      setFirstTabActive : (tabs) ->
        _.each tabs, (tab) ->
          tab.active = $state.includes(tab.inclusionFlag)
          yes
        tabs

      getTab : ->
        _.find @getTabs(), (tab) -> tab.active

      setTab : (newTab, tabs = []) ->
        tabs = @getTabs() if tabs.length is 0
        _.each tabs, (tab) ->
          tab.active = tab is newTab
          yes
        $localStorage[@key] = tabs

    new HeaderTabService()

]
