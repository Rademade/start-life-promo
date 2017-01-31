app.controller 'roundTripController', [
  'Datepicker', 'FlightFactory', 'Selector', 'linkOpener', '$scope', 'TravelFactory', 'linkGenerator', '$timeout',
  '$element', 'inputFocuser',
  (Datepicker, FlightFactory, Selector, linkOpener, $scope, TravelFactory, linkGenerator, $timeout, $element, inputFocuser) ->

    E = $element[0]
    @sync = $scope.syncService

    @isFormSubmitted = no
    @isDateFromSelected = no
    @isDateToSelected = no
    @dateFrom = new Datepicker()
    @dateTo = new Datepicker()

    @directionFrom = new FlightFactory(@sync.getDirection())
    @directionTo = new FlightFactory()

    @flightType = new FlightFactory()

    @exactDatesFrom = new Selector(@dateTo.getOptions())
    @exactDatesTo = new Selector(@dateFrom.getOptions())

    @factory = new TravelFactory([@dateFrom, @dateTo], @flightType, [@exactDatesFrom, @exactDatesTo])

    setTimeout ->
      inputFocuser.focus({ element : E, index : 0 })
    , 0

    @closeAllAccept = (element) ->
      @factory.closeAllAccept(element)

    @open = (site) ->
      @isFormSubmitted = yes

      directionFrom = @directionFrom.getDirection()
      directionTo = @directionTo.getDirection()
      dateFrom = @dateFrom.getDate()
      dateTo = @dateTo.getDate()

      if directionFrom && directionTo && dateFrom && dateTo
        params = @getParams(directionFrom, directionTo, dateFrom, dateTo, site)
        link = linkGenerator.getFlightLink(params)
        linkOpener.open(link)

    @getParams = (directionFrom, directionTo, dateFrom, dateTo, site) ->
      trip : 'roundtrip'
      site : site
      date_to : @formatDate(dateTo)
      date_from : @formatDate(dateFrom)
      passengers : @getPassengers()
      flight_class : @flightType.getSelectedFlightClass()
      direction_to : directionTo
      direction_from : directionFrom
      exact_dates_to : @exactDatesTo.getSelectedName()
      exact_dates_from : @exactDatesFrom.getSelectedName()
      airport_code_to : @directionTo.getAirportCode()
      airport_code_from : @directionFrom.getAirportCode()
      airport_id_to : @directionTo.getAirportId()
      airport_id_from : @directionFrom.getAirportId()

    @getPassengers = () ->
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

    @isDateError = (date) ->
      !date.getDate() && @isFormSubmitted

    @onDateFromSelected = () ->
      @isDateFromSelected = yes
      dateFrom = @dateFrom.getDate()
      dateTo = @dateTo.getDate()
      firstDayOfMonth = new Date(1)

      if @isDateToSelected && @isDatesCorrect()
        @dateFrom.setInterval(dateFrom, dateTo)
        @dateTo.setInterval(dateFrom, dateTo)
        @dateTo.turnOffInterval(firstDayOfMonth, dateFrom)
      else
        @dateTo.setDate(dateFrom)
        @dateTo.turnOffInterval(firstDayOfMonth, dateFrom)
        @dateTo.open()

    @onDateToSelected = () ->
      @isDateToSelected = yes
      dateFrom = @dateFrom.getDate()
      dateTo = @dateTo.getDate()

      if @isDateFromSelected && @isDatesCorrect()
        @dateFrom.setInterval(dateFrom, dateTo)
        @dateTo.setInterval(dateFrom, dateTo)
      else
        @dateTo.setDate(dateTo)
        @dateFrom.setActiveDay(dateTo)
        @dateFrom.open()

    @isDatesCorrect = () ->
      correct = no
      dateFrom = @dateFrom.getDate()
      dateTo = @dateTo.getDate()
      if dateFrom && dateTo
        correct = dateFrom < dateTo
      correct

    @setCity = () ->
      setTimeout ->
        inputFocuser.focus({ element : E, index : 1 })
      , 0

    @departDateON = ->
      $timeout =>
        @dateFrom.toggle()
        inputFocuser.blur({ element : E, index : 1 })
        @closeAllAccept(@dateFrom)

    @getDateToDatapickerCss = () ->
      @dateTo.getClass(@isFormSubmitted)

    return

]
