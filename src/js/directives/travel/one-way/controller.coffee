app.controller 'oneWayController', [
  'Datepicker', 'FlightFactory', 'Selector', 'linkOpener', '$scope', 'TravelFactory', 'linkGenerator', '$element',
  '$timeout', 'inputFocuser',
  (Datepicker, FlightFactory, Selector, linkOpener, $scope, TravelFactory, linkGenerator, $element, $timeout, inputFocuser) ->

    E = $element[0]
    @sync = $scope.syncService
    @isFormSubmitted = no

    @dateFrom = new Datepicker()
    @exactDatesFrom = new Selector(@dateFrom.getOptions())

    @directionFrom = new FlightFactory(@sync.getDirection())
    @directionTo = new FlightFactory()
    @flightType = new FlightFactory()

    @factory = new TravelFactory([@dateFrom], @flightType, [@exactDatesFrom])

    setTimeout ->
      inputFocuser.focus({ element : E, index : 0 })
    , 0

    @closeAllAccept = (element) ->
      @factory.closeAllAccept(element)

    @open = (site) ->
      @isFormSubmitted = yes

      directionFrom = @directionFrom.getDirection()
      directionTo = @directionTo.getDirection()
      dateFrom  = @dateFrom.getDate()

      if directionFrom && directionTo && dateFrom
        params = @getParams(directionFrom, directionTo, dateFrom, site)
        link = linkGenerator.getFlightLink(params)
        linkOpener.open(link)

    @departDateON = ->
      $timeout =>
        @dateFrom.toggle()
        inputFocuser.blur({ element : E, index : 1 })
        @closeAllAccept(@dateFrom)

    @getParams = (directionFrom, directionTo, dateFrom, site) ->
      trip : 'oneway'
      site : site
      date_from : @formatDate(dateFrom)
      passengers : @getPassengers()
      flight_class : @flightType.getSelectedFlightClass().name || @flightType.getSelectedFlightClass()
      direction_to : directionTo
      direction_from : directionFrom
      exact_dates_from : @exactDatesFrom.getSelectedName()
      airportCode_to : @directionTo.getAirportCode()
      airportCode_from : @directionFrom.getAirportCode()
      airport_id_to : @directionTo.getAirportId()
      airport_id_from : @directionFrom.getAirportId()

    @getPassengers = ->
      _.map @flightType.getFlightTypes(), (passenger) ->
        name : passenger.name.toLowerCase()
        count : passenger.count

    @formatDate = (rawDate) ->
      if rawDate
        date = new Date(rawDate)
        [date.getFullYear(), date.getMonth() + 1, date.getDate()].join('-')
      else
        ''

    @isDirectionError = (direction) ->
      !direction.getDirection() && @isFormSubmitted

    @setCity = ->
      setTimeout ->
        inputFocuser.focus({ element : E, index : 1 })
      , 0

    return

]
