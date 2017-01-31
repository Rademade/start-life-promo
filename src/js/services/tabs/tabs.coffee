app.factory 'TabService', [ '$localStorage', ($localStorage) ->

  class TabService

    constructor : () ->
      @configured = $localStorage[@key + 'Configured'] || no
      @isInited = no

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

    setTabs : (tabs = []) ->
      if tabs.length
        $localStorage[@key] = tabs
        @configured = yes

]
