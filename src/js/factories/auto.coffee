app.factory 'AutoFactory', [
  'autocomplete', 'Selector', '$localStorage', '$q'
  (autocomplete, Selector, $localStorage, $q) ->

    class AutoFactory

      MAX_CARS_COUNT = 3
      MAX_CAR_AGE = 30

      SITES = [
        { name : 'Cars.com' },
        { name : 'Autotrader.com' },
        { name : 'Ebay.com' },
        { name : 'Craigslist.org' }
      ]

      TYPES = [
        { name : 'All', active : yes },
        { name : 'New', active : no },
        { name : 'Used', active : no }
      ]

      CYLINDERS = [
        'Any', '1-cylinder', '2-cylinder', '3-cylinder', '4-cylinder', '5-cylinder', '6-cylinder', '8-cylinder',
        '10-cylinder', '12-cylinder'
      ]

      BODY_STYLES = [
        'Any', 'Cargo Van', 'Convertible', 'Coupe', 'Crew Cab Pickup', 'Hatchback',
        'Minivan', 'Passenger Van', 'Regular Cab Pickup', 'Sedan', 'SUV', 'Wagon',
      ]

      COLORS = [
        'Any', 'Beige', 'Black', 'Blue', 'Brown', 'Gold', 'Gray', 'Green', 'Orange', 'Red', 'Silver', 'White', 'Yellow'
      ]

      FUELS = ['Any', 'Gasoline', 'E-85/Gasoline', 'Gasoline Hybrid', 'Diesel', 'Electric', 'Compressed Natural Gas' ]
      DRIVE_TYPE = ['Any', '2WD', '4WD', 'AWD', 'FWD', 'RWD' ]
      TRANSMISSIONS = ['Any', 'Manual', 'Automatic', 'Automanual', 'CVT']

      key = 'carMakes'
      configured = $localStorage[key + 'Configured'] || no
      carMakesPromise = $q.defer()

      constructor : (ableToAdd, ableToRemove) ->
        @isAbleToAdd = ableToAdd || no
        @isAbleToRemove = ableToRemove || no
        @cars = []
        @car = {}
        @zipCode = ''
        @selectors =
          fuel : new Selector @getFuels()
          mileAge : new Selector @getMileAges()
          minYear : new Selector @getYears()
          maxYear : new Selector @getYears()
          cylinder : new Selector @getCylinders()
          bodyStyle : new Selector @getBodyStyles()
          driveType : new Selector @getDriveTypes()
          transmission : new Selector @getTransmissions()
          exteriorColor : new Selector @getColors()
          interiorColor : new Selector @getColors()
          minPrice : new Selector @getPrices()
          maxPrice : new Selector @getPrices()
        @isFormSubmitted = no
        @isModelShowed = no

      getMakes : ->
        if configured
          carMakesPromise.resolve($localStorage[key])
        else
          @configure()
        carMakesPromise.promise

      configure : ->
        autocomplete.get('cars').then (cars) =>
          if cars.length
            $localStorage[key + 'Configured'] = yes
            $localStorage[key] = cars
            configured = yes
            carMakesPromise.resolve($localStorage[key])

      getCars : ->
        @cars

      addNewCar : ->
        @getMakes().then (makes) =>
          if @cars.length < MAX_CARS_COUNT
            @cars.push
              make : new Selector makes
              model : new Selector
              isModelDisabled : yes
            @update()

      removeCar : (newCar) ->
        if @cars.length > 1
          _.remove @cars, (car) -> car is newCar
          @update()

      update : ->
        @setAbleToAdd(@cars.length < MAX_CARS_COUNT)
        @setAbleToRemove(@cars.length > 1)

      setFormSubmitted : (submitted) ->
        @isFormSubmitted = submitted

      isYearValid : (params) ->
        params.minYear < params.maxYear

      isPriceValid : (params) ->
        params.minPrice < params.maxPrice

      isZipCodeValid : () ->
        @zipCode.length > 0

      isYearErrorShowed : () ->
        minYear = @selectors.minYear.getSelected()?.name
        maxYear = @selectors.maxYear.getSelected()?.name
        @isFormSubmitted && minYear > maxYear

      isPriceErrorShowed : () ->
        minPrice = @selectors.minPrice.getSelected()?.value
        maxPrice = @selectors.maxPrice.getSelected()?.value
        @isFormSubmitted && minPrice > maxPrice

      isZipCodeErrorShowed : () ->
        @isFormSubmitted && !@isZipCodeValid()

      isParamsValid : (params) ->
        isValid = @isZipCodeValid()
        isValid &&= @isPriceValid(params) if params.minPrice && params.maxPrice
        isValid &&= @isYearValid(params) if params.minYear && params.maxYear
        isValid

      getBaseParams : () ->
        car_type : @type()?.name
        fuel : @selectors.fuel.getSelected()?.name
        mile_age : @selectors.mileAge.getSelected()?.value
        cylinders : @selectors.cylinder.getSelected()?.name
        bodyStyle : @selectors.bodyStyle.getSelected()?.name
        drive_type : @selectors.driveType.getSelected()?.name
        transmission : @selectors.transmission.getSelected()?.name
        exterior_color : @selectors.exteriorColor.getSelected()?.name
        interior_color : @selectors.interiorColor.getSelected()?.name
        min_year : @selectors.minYear.getSelected()?.name
        max_year : @selectors.maxYear.getSelected()?.name
        min_price : @selectors.minPrice.getSelected()?.value
        max_price : @selectors.maxPrice.getSelected()?.value
        zip_code : @zipCode

      getCarsParams : () ->
        _.map @cars, (car) => @getCarParams(car)

      getCarParams : (car) ->
        make : car.make.getSelected()
        model : car.model.getSelected()

      setAbleToAdd : (ableToAdd) ->
        @isAbleToAdd = ableToAdd

      setAbleToRemove : (ableToRemove) ->
        @isAbleToRemove = ableToRemove

      getAbleToAdd : ->
        @isAbleToAdd

      getAbleToRemove : ->
        @isAbleToRemove

      setCar : (car) ->
        @car = car

      getSites : ->
        SITES

      getPrices : ->
        _.concat @generatePrices(25), @generatePrices(15, 5, 30)

      generatePrices : (count, step = 1, padding = 1) ->
        prices = _.map new Array(count), (item, index) ->
          name : "$#{index * step + padding},000"
          value : (index * step + padding) * 1000
        prices.unshift(name : 'Any', value : '')
        prices

      getMileAges : ->
        ages = @generateMiles(9, 10, 10)
        ages = _.concat ages, @generateMiles(4, 50, 100)
        ages.push
          name : '500,000 Miles'
          value : 500000
        ages.unshift(name : 'Any', value : '')
        ages

      generateMiles : (count, step = 1, padding = 1) ->
        _.map new Array(count), (item, index) ->
          name : "#{index * step + padding},000 Miles"
          value : (index * step + padding) * 1000

      getModels : ->
        if @car
          @car.models

      getCylinders : ->
        _.map CYLINDERS, (cylinder) -> { name : cylinder }

      getFuels : ->
        _.map FUELS, (fuel) -> { name : fuel }

      getDriveTypes : ->
        _.map DRIVE_TYPE, (type) -> { name : type }

      getTransmissions : ->
        _.map TRANSMISSIONS, (transmission) -> { name : transmission }

      getColors : ->
        _.map COLORS, (color) -> { name : color }

      getBodyStyles : ->
        _.map BODY_STYLES, (style) -> { name : style }

      getYears : ->
        startYear = (new Date()).getFullYear() - MAX_CAR_AGE
        years = _.map new Array(MAX_CAR_AGE), (item, index) ->
          name : startYear + index + 1
        _.orderBy years, ['name'], ['desc']

      getTypes : ->
        TYPES

      selectType : (name) ->
        _.each TYPES, (type) ->
          type.active = type.name is name
          yes

      type : ->
        _.find TYPES, (type) -> type.active is yes

      getSelectors : ->
        @selectors

]
