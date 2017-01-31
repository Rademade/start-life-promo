app.factory 'TravelFactory', [ 'Datepicker', 'FlightFactory', (Datepicker, FlightFactory) ->

  class TravelFactory

    TYPES = [
      { name : 'Round-trip', active : yes },
      { name : 'One way', active : no },
      { name : 'Multi-city', active : no }
    ]

    TABS = [
      { name : 'Flights', active : yes },
      { name : 'Hotels', active : no }
    ]

    constructor : (datepickers, flightType, selectors) ->
      @datepickers = datepickers
      @flightType = flightType
      @selectors = selectors

    getTabs : ->
      TABS

    setTab : (name) ->
      _.each TABS, (tab) ->
        tab.active = tab.name is name
        yes

    isTab : (name) ->
      result = no
      _.each TABS, (tab) ->
        if tab.name is name
          result = tab.active
        yes
      result

    setDatepickers : (datepickers) ->
      @datepickers = datepickers

    setType : (name) ->
      _.each TYPES, (type) ->
        type.active = type.name is name
        yes

    isType : (name) ->
      result = no
      _.each TYPES, (type) ->
        if type.name is name
          result = type.active
        yes
      result

    getTypes : ->
      TYPES

    closeAllAccept : (element) ->
      if element instanceof Datepicker
        @closeElements(@datepickers, element)
        @closeElements(@selectors)
        @flightType.close()
      else if element instanceof FlightFactory
        @closeElements(@datepickers)
        @closeElements(@selectors)

    closeElements : (elements, exception) ->
      _.each elements, (element) =>
        unless element is exception
          element.close()
        yes

]
