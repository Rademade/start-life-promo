app.service 'synchronization', [
  '$localStorage', 'headerTabService', 'Setting', 'bookmarkService', 'newsService', 'searchTabService',
  ($localStorage, headerTabService, Setting, bookmarkService, newsService, searchTabService) ->

    MAN = 'M'
    WOMAN = 'F'

    SEXES = [
      { name : MAN, active : no },
      { name : WOMAN, active : no }
    ]

    SOCIAL_ACCOUNTS = [
      { name : 'Facebook', key : 'facebook', class : 'mod-fb' },
      { name : 'Linkedin', key : 'linkedin', class : 'mod-in' },
      { name : 'Google',  key : 'google_oauth2', class : 'mod-gp' }
    ]

    USER = 'user'
    ID = 'id'
    EMAIL = 'email'
    DIRECTION = 'direction'
    TRAVELLERS = 'travellers'
    CITY = 'city'
    SEX = 'sex'
    BIRTHDAY = 'birthday'
    FIRST_NAME = 'firstName'
    LAST_NAME = 'lastName'
    COUNTRY = 'country'
    LANGUAGE = 'language'
    UPDATED = 'updated'
    ACCOUNTS = 'accounts'
    SETTINGS = 'settings'

    HEADER_TABS = 'headerTabs'
    SEARCH_TABS = 'searchTabs'
    BOOKMARKS = 'bookmarks'
    SEARCH_SITES = 'searchSites'
    NEWS_SITES = 'newsSites'

    syncCbs = []
    synced = no

    service =

      onSync : (cb) ->
        cb() if synced
        syncCbs.push(cb)

      setSettingsUpdated : (updated) ->
        $localStorage[USER][SETTINGS][UPDATED] = updated if @isLogined()
        @sync()

      sync : ->
        synced = yes
        _.each syncCbs, (syncCb) =>
          syncCb() if syncCb
          yes
        @syncSettings()

      getSettings : ->
        $localStorage[USER][SETTINGS]

      syncSettings : ->
        if @getUserId() && @getUser().settings.updated
          settings = @serialize(@getSettings())
          new Setting().sync(settings)
          @setSettingsUpdated(no)

      loadSettings : ->
        new Setting().load(id : @getUserId()).then (data) =>
          @applySetttings(data)

      serialize : (settings) ->
        headerTabs : JSON.stringify settings[HEADER_TABS]
        bookmarks : JSON.stringify settings[BOOKMARKS]
        searchSites : JSON.stringify settings[SEARCH_SITES]
        newsSites : JSON.stringify settings[NEWS_SITES]
        id : @getUserId()

      applySetttings : (data) ->
        @setHeaderTabs(JSON.parse(data.headerTabs)) if data.headerTabs
        @setSearchTabs(JSON.parse(data.searchTabs)) if data.searchTabs
        @setBookmarks(JSON.parse(data.bookmarks)) if data.bookmarks
        @setNewsSites(JSON.parse(data.newsSites)) if data.newsSites
        @setSearchSites(JSON.parse(data.searchSites)) if data.searchSites
        @applySetttingsInServices()

      applySetttingsInServices : ->
        settings = @getSettings()
        headerTabService.setTabs(settings.headerTabs) if settings?.headerTabs
        bookmarkService.setBookmarks(settings.bookmarks) if settings?.bookmarks
        newsService.setSites(settings.newsSites) if settings?.newsSites
        searchTabService.setTabs(settings.searchSites) if settings?.searchSites

      setHeaderTabs : (tabs) ->
        $localStorage[USER][SETTINGS][HEADER_TABS] = tabs || []
        @setSettingsUpdated(yes)

      setSearchTabs : (tabs) ->
        $localStorage[USER][SETTINGS][SEARCH_TABS] = tabs || []
        @setSettingsUpdated(yes)

      setSearchSites : (tabs) ->
        $localStorage[USER][SETTINGS][SEARCH_SITES] = tabs || []
        @setSettingsUpdated(yes)

      setBookmarks : (bookmarks) ->
        $localStorage[USER][SETTINGS][BOOKMARKS] = bookmarks || []
        @setSettingsUpdated(yes)

      setNewsSites : (sites) ->
        $localStorage[USER][SETTINGS][NEWS_SITES] = sites || []
        @setSettingsUpdated(yes)

      getUser : ->
        $localStorage[USER]

      setUser : (user) ->
        $localStorage[USER][SEX] = if user.sex? then user.sex else yes
        $localStorage[USER][BIRTHDAY] = user.birthday if user.birthday
        $localStorage[USER][FIRST_NAME] = user.firstName if user.firstName
        $localStorage[USER][LAST_NAME] = user.lastName if user.lastName
        $localStorage[USER][COUNTRY] = user.country if user.country
        $localStorage[USER][LANGUAGE] = user.language if user.language
        $localStorage[USER][EMAIL] = user.email if user.email
        $localStorage[USER][ACCOUNTS] = user.accounts || []
        @syncSettings()

      setDirection : (direction) ->
        $localStorage[USER][DIRECTION] = direction
        $localStorage[USER][CITY] = direction.split(' ')[0] if direction

      getDirection : () ->
        $localStorage[USER][DIRECTION]

      setTravelersData : (data) ->
        $localStorage[USER][TRAVELLERS] = data

      getTravelersData : () ->
        $localStorage[USER][TRAVELLERS]

      setCity : (city) ->
        $localStorage[USER][CITY] = city

      getGoogleId : () ->
        _.find(@getUser().accounts, (account) -> account.provider is 'google_oauth2')?.uid

      getUserId : () ->
        $localStorage[USER][ID]

      setUserId : (userId) ->
        $localStorage[USER][ID] = userId

      isLogined : () ->
        if _.isString(@getUserId()) && @getUserId().length > 0 then yes else no

      getSocialAccounts : ->
        SOCIAL_ACCOUNTS

      isConnectedToSocialAccount : (key) ->
        accounts = @getUser().accounts
        isConnected = no
        if accounts.length
          _.each accounts, (account) ->
            if account.provider is key
              isConnected = yes
            yes
        isConnected

      getSexes : ->
        SEXES

      getSex : ->
        if @getUser().sex then MAN else WOMAN

      reset : ->
        fields = [ID, EMAIL, BIRTHDAY, FIRST_NAME, LAST_NAME, SEX, COUNTRY, LANGUAGE, DIRECTION, CITY, ACCOUNTS, SETTINGS]
        settings = [HEADER_TABS, SEARCH_TABS, BOOKMARKS, SEARCH_SITES, NEWS_SITES, UPDATED]
        user = {}

        _.each fields, (field) =>
          if field is SETTINGS
            user[field] = {}
            _.each settings, (setting) =>
              user[field][setting] = ''
            yes
          else
            user[field] = ''
          yes
        $localStorage[USER] = user

    init = ->
      service.reset() if _.isUndefined($localStorage[USER])

    init()

    return service

]
