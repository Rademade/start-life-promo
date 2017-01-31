app.factory 'HotelFactory', [ 'Datepicker', 'FlightFactory', (Datepicker, FlightFactory) ->

  class HotelFactory

    MAX_ROOMS_COUNT  = 9
    MAX_GUESTS_COUNT = 30

    SITES = [
      { name : 'Expedia.com' },
      { name : 'Kayak.com' },
      { name : 'Booking.com' },
      { name : 'Hotels.com' },
      { name : 'Tripadvisor.com' }
    ]

    isDateFromSelected = no
    isDateToSelected   = no

    constructor : (direction, guestsCount) ->
      @isOpenSelector   = no
      @dateFrom = new Datepicker()
      @dateTo = new Datepicker()
      @city = new FlightFactory(direction)
      @hotelParams = [
        { name : 'Rooms', count : Math.floor(guestsCount / 2) || 1 },
        { name : 'Guests', count : guestsCount || 2 }
      ]

    getIsOpen : ->
      @isOpenSelector

    open : ->
      @isOpenSelector = yes

    close : ->
      @isOpenSelector = no

    toggle : ->
      @isOpenSelector = !@isOpenSelector

    getHotelParams : ->
      @hotelParams

    incrementCount : (name) ->
      item = @getParamsCount(name)
      switch item.name
        when 'Rooms'
          if item.count < MAX_ROOMS_COUNT
            item.count += 1
        when 'Guests'
          if item.count < MAX_GUESTS_COUNT
            item.count += 1

    decrementCount : (name) ->
      item = @getParamsCount(name)
      switch item.name
        when 'Rooms'
          if item.count > 1
            item.count -= 1
        when 'Guests'
          if item.count > 1
            item.count -= 1

    getParamsCount : (name) ->
      _.find(@getHotelParams(), (item) -> item.name is name)

    getSites : ->
      SITES

    getSelectors : ->
      @selectors

    getParams : ->
      city : @city.getDirection()
      date_to : @formatDate(@dateTo.getDate())
      date_from : @formatDate(@dateFrom.getDate())
      guests : @getParamsCount('Guests').count
      rooms : @getParamsCount('Rooms').count

    onDateFromSelected : ->
      isDateFromSelected = yes
      dateFrom = @dateFrom.getDate()
      dateTo = @dateTo.getDate()
      firstDayOfMonth = new Date(1)

      if isDateToSelected && @isDatesCorrect()
        @dateFrom.setInterval(dateFrom, dateTo)
        @dateTo.setInterval(dateFrom, dateTo)
        @dateTo.turnOffInterval(firstDayOfMonth, dateFrom)
      else
        @dateTo.setDate(dateFrom)
        @dateTo.turnOffInterval(firstDayOfMonth, dateFrom)
        @dateTo.open()

    onDateToSelected : ->
      isDateToSelected = yes
      dateFrom = @dateFrom.getDate()
      dateTo = @dateTo.getDate()

      if isDateFromSelected && @isDatesCorrect()
        @dateFrom.setInterval(dateFrom, dateTo)
        @dateTo.setInterval(dateFrom, dateTo)
      else
        @dateFrom.setDate(dateTo)
        @dateFrom.open()

    isOpen : (datepicker) ->
      datepicker.getIsOpen()

    closeAllDatepickersExcept : (newDatepicker) ->
      _.each [@dateFrom, @dateTo], (datepicker) ->
        unless datepicker is newDatepicker
          datepicker.close()
        yes
      @close()

    formatDate : (rawDate) ->
      if rawDate
        date = new Date(rawDate)
        [date.getFullYear(), date.getMonth() + 1, date.getDate()].join('-')
      else
        ''

    isDatesCorrect : ->
      correct = no
      dateFrom = @dateFrom.getDate()
      dateTo = @dateTo.getDate()
      if dateFrom && dateTo
        correct = dateFrom < dateTo
      correct

]
