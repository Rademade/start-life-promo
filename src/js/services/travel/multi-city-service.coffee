app.service 'travelMultiSityService', [
  'FlightFactory', 'TravelFactory', 'Datepicker',
  (FlightFactory, TravelFactory, Datepicker) ->

    MAX_FLIGHTS = 5
    WINDOW_RESIZE_WIDTH = 1200
    TRIP_KEY = 'multicity'

    flights = []
    flight = {}
    datepickerds = []
    currentDirection = ''
    modeRight = yes

    flightFactory = new FlightFactory()

    factories =
      flight : flightFactory
      travel : new TravelFactory(datepickerds, flightFactory)

    setDirection : (direction) ->
      currentDirection = direction

    getFactories : () ->
      factories

    getFlights : () ->
      flights

    createFlight : (calendarModeRight) ->
      directionFrom : new FlightFactory(currentDirection)
      directionTo : new FlightFactory()
      dateTo : new Datepicker(calendarModeRight)

    destroyFlight : (newFlight) ->
      _.remove flights, (flight) -> flight is newFlight
      factories.travel.setDatepickers @getDatepickers()

    addFlight : (calendarModeRight) ->
      if flights.length < MAX_FLIGHTS
        flights.push @createFlight(calendarModeRight)
        factories.travel.setDatepickers @getDatepickers()

    getDatepickers : () ->
      _.map flights, (flight) -> flight.dateTo

    getParams : (site) ->
      params = @getBaseParams(site)
      _.each flights, (flight) =>
        params.flights.push @getFlightParams(flight)
        yes
      params

    getBaseParams : (site) ->
      factory = factories.flight
      trip : TRIP_KEY
      site : site
      flights : []
      flight_class : factory.getSelectedFlightClass()
      passengers : _.map factory.getFlightTypes(), (passenger) ->
        name : passenger.name.toLowerCase()
        count : passenger.count

    getFlightParams : (flight) ->
      direction_from : flight.directionFrom.getDirection()
      direction_to : flight.directionTo.getDirection()
      airport_code_from : flight.directionFrom.getAirportCode()
      airport_code_to : flight.directionTo.getAirportCode()
      date_from : @formatDate(flight.dateTo.getDate())

    formatDate : (rawDate) ->
      if rawDate
        date = new Date(rawDate)
        [date.getFullYear(), date.getMonth() + 1, date.getDate()].join('-')
      else
        ''

    isFlightsValid : (flights) ->
      isValid = no
      _.each flights, (flight) =>
        isValid = flight.direction_from && flight.direction_to && flight.date_from
      isValid

    closeAllAccept : (element) ->
      factories.travel.closeAllAccept(element)

]
