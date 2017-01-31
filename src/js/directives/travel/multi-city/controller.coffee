app.controller 'multiCityController', [
  'linkOpener', '$scope', '$window', 'travelMultiSityService', 'linkGenerator', '$timeout', '$element', 'inputFocuser',
  (linkOpener, $scope, $window, travelMultiSityService, linkGenerator, $timeout, $element, inputFocuser) ->

    RESIZE_POINT = 1158
    E = $element[0]

    @sync = $scope.syncService
    @service = travelMultiSityService
    @factories = @service.getFactories()
    @flights = []
    @isFormSubmitted = no

    @service.setDirection @sync.getDirection()

    setTimeout ->
      inputFocuser.focus({ element : E, index : 0 })
    , 0

    @selectDatepicker = (index = 0) ->
      datepicker = @factories.travel.datepickers[index]
      datepicker.toggle()

    @updateFlights = () ->
      @flights = []
      @flights = @service.getFlights()

    @addFlight = () ->
      @service.addFlight(@isCalendarModeRight())

    @open = (site) ->
      @isFormSubmitted = yes
      params = travelMultiSityService.getParams(site)
      if travelMultiSityService.isFlightsValid(params.flights)
        link = linkGenerator.getFlightLink(params)
        linkOpener.open(link)

    @isDirectionError = (direction) ->
      !direction.getDirection() && @isFormSubmitted

    @setCity = (index) ->
      setTimeout ->
        inputFocuser.focus({ element : E, index : index })
      , 0

    @departDateON = (index, dpIdnex) ->
      $timeout =>
        inputFocuser.blur({ element : E, index : index })
        @selectDatepicker(dpIdnex)

    onResize = () =>
      $scope.$apply () =>
        _.each @flights, (flight) =>
          flight.dateTo.setRightMode @isCalendarModeRight()
          yes

    window.addEventListener 'resize', onResize

    $scope.$on '$destroy', () ->
      window.removeEventListener 'resize', onResize

    @isCalendarModeRight = () ->
      window.innerWidth > RESIZE_POINT

    @addFlight() if @service.getFlights().length is 0
    @updateFlights()

    return

]
