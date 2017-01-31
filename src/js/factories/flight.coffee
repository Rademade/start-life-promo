app.factory 'FlightFactory', [ () ->

  class FlightFactory

    MAX_PASSENGERS_COUNT = 10

    FLIGHT_TYPES = [
      { name : 'Adults', count : 1, ageRange : '18-64' },
      { name : 'Seniors', count : 0, ageRange : '65+' },
      { name : 'Youths', count : 0, ageRange : '12-17' }
      { name : 'Children', count : 0, ageRange : '0-11' }
    ]

    FLIGHT_CLASSES = [
      { name : 'Economy', active : yes },
      { name : 'Premium Economy', active : no },
      { name : 'Business', active : no  },
      { name : 'First', active : no }
    ]

    constructor : (direction = '') ->
      @isOpen = no
      @flightTypes = FLIGHT_TYPES
      @flightClasses = FLIGHT_CLASSES
      @direction = direction
      @airportCode = ''
      @id = ''

    getFlightTypes : ->
      @flightTypes

    getFlightClasses : ->
      @flightClasses

    getIsOpen : ->
      @isOpen

    open : ->
      @isOpen = yes

    close : ->
      @isOpen = no

    toggle : ->
      @isOpen = !@isOpen

    incrementCount : (type) ->
      if @getTravelersCount() < MAX_PASSENGERS_COUNT
        type.count += 1

    decrementCount : (type) ->
      if @getTravelersCount() > 1 && type.count > 0
        type.count -= 1

    setTravelerTypes : (newTypes) ->
      _.each newTypes, (newType) =>
        _.find(@flightTypes, (type) -> type.name is newType.name).count = newType.count
        yes

    getTravelersCount : (typeName) ->
      if typeName
        _.filter(@flightTypes, (type) -> type.name is typeName)[0].count
      else
        _.sum _.map(@flightTypes, (type) -> type.count)

    setSelectedFlightClass : (name) ->
      _.each @flightClasses, (item) ->
        item.active = item.name is name
        yes

    getSelectedFlightClass : ->
       _.filter(@flightClasses, (item) -> item.active is yes)[0].name

    setDirection : (direction) ->
      @direction = direction

    getDirection : ->
      @direction

    getCity : ->
      @direction.split(' ')[0] if @direction

    setAirportCode : (code) ->
      @airportCode = code

    getAirportCode : ->
      @airportCode

    setAirportId : (id) ->
      @airportId = id

    getAirportId : ->
      @airportId
]
