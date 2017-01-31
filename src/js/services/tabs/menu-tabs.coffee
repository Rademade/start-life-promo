app.service 'menuTabService', [
  'TabService', '$localStorage', '$state',
  (TabService, $localStorage, $state) ->

    class MenuTabService extends TabService

      TABS = [
        { sref : 'public.multi-search.travel', name : 'Travel', class : 'mod-travel', active : no },
        { sref : 'public.multi-search.auto', name : 'Auto', class : 'mod-cars', active : no },
        { sref : 'public.multi-search.homes', name : 'Homes', class : 'mod-homes', active : no },
        { sref : 'public.index', name : 'Shopping', class : 'mod-shopping is-disabled', active : no },
        { sref : 'public.index', name : 'Jobs', class : 'mod-jobs is-disabled', active : no },
        { sref : 'public.index', name : 'Dating', class : 'mod-dating is-disabled', active : no }
      ]

      constructor : () ->
        @tabs = TABS
        @key = 'menuTabs'
        @isInited = no
        super

      getTabs : ->
        if @configured
          tabs = $localStorage[@key]
          unless @isInited
            tabs = @updateActiveTab(tabs)
            @isInited = yes
          tabs
        else
          $localStorage[@key + 'Configured'] = yes
          $localStorage[@key] = @updateActiveTab(@tabs)

      updateActiveTab : (tabs) ->
        _.each tabs, (tab, index) =>
          if tab.sref is $state.current.name
            tab.active = yes
          yes
        tabs

      getTab : ->
        _.find @getTabs(), (tab) -> tab.active

      setTab : (newTab) ->
        tabs = @getTabs()
        _.each tabs, (tab) ->
          tab.active = tab is newTab
          yes
        $localStorage[@key] = tabs

      currentTab : () ->
        _.find(@getTabs(), (tab) -> tab.active is yes)

      isActive : (name) ->
        @currentTab().name is name

    new MenuTabService()

]
