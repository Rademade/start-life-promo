app.factory 'HomeFactory', [ 'Selector', (Selector) ->

  class HomeFactory

    MAX_HOME_AGE = 60

    SITES = [
      { name : 'Realtor.com' },
      { name : 'Zillow.com' },
      { name : 'Trulia.com' },
      { name : 'Craigslist.com' }
    ]

    TYPES = [
      { name : 'For sale', active : yes },
      { name : 'For rent', active : no }
    ]

    PROPERTY_TYPES = [
      'All', 'Single Family home', 'Condo', 'Townhome', 'Coop', 'Apartment', 'Loft', 'TIC', 'Mobile/Manufactured',
      'Farm/Ranch', 'Lot/Land', 'Multi-Family Home', 'Income/Investment', 'Houseboat'
    ]

    LOT_SIZES = [
      { name : 'Any', value : 0 },
      { name : '1/2+ acre', value : 0.5 },
      { name : '1+ acre', value : 1 },
      { name : '2+ acre', value : 2 },
      { name : '5+ acre', value : 5 },
      { name : '10+ acre', value : 10 },
      { name : '20+ acre', value : 20 }
    ]

    BATHS = ['Any', '1+', '2+', '3+', '4+', '5+']
    BEDS  = ['Any', 'Studio', '1+', '2+', '3+', '4+', '5+']

    constructor : () ->
      @selectors =
        openHouses : no
        isFormSubmitted : no
        location : new Selector
        beds : new Selector @getBeds()
        baths : new Selector @getBaths()
        minPrice : new Selector @getMinPrices()
        maxPrice : new Selector @getMaxPrices()
        minLotSize : new Selector @getLotSizes()
        maxLotSize : new Selector @getLotSizes()
        propertyType : new Selector @getPropertyTypes()
        minHouseSize : new Selector @getHouseSizes()
        maxHouseSize : new Selector @getHouseSizes()
        minYearBuild : new Selector @getYears()
        maxYearBuild : new Selector @getYears()

    getParams : ->
      home_type : @type()?.name
      beds : @selectors.beds.getSelected()?.name
      baths : @selectors.baths.getSelected()?.name
      location : @selectors.location.getSelected()
      min_price : @selectors.minPrice.getSelected()?.value
      max_price : @selectors.maxPrice.getSelected()?.value
      open_houses : @selectors.openHouses
      min_lot_size : @selectors.minLotSize.getSelected()?.value
      max_lot_size : @selectors.maxLotSize.getSelected()?.value
      property_type : @selectors.propertyType.getSelected()?.name
      min_house_size : @selectors.minHouseSize.getSelected()?.value
      max_house_size : @selectors.maxHouseSize.getSelected()?.value
      min_year_build : @selectors.minYearBuild.getSelected()?.name
      max_year_vuild : @selectors.maxYearBuild.getSelected()?.name

    isValid : ->
      params = @getParams()
      @isHouseValid(params) && @isLotValid(params) && @isYearValid(params) && !@hasLocationError()

    isHouseValid : (params) ->
      if params.min_house_size && params.max_house_size
        params.min_house_size <= params.max_house_size
      else yes

    isLotValid : (params) ->
      if params.min_lot_size && params.max_lot_size
        params.min_lot_size <= params.max_lot_size
      else yes

    isYearValid : (params) ->
      if params.min_year_build && params.max_year_build
        params.min_year_build <= params.max_year_build
      else yes

    hasLocationError : ->
      !@selectors.location.getSelected() && @selectors.isFormSubmitted

    hasPriceError : ->
      minPrice = @selectors.minPrice.getSelected()?.value
      maxPrice = @selectors.maxPrice.getSelected()?.value
      @selectors.isFormSubmitted && minPrice > maxPrice

    getSites : ->
      SITES

    getTypes : ->
      TYPES

    setType : (name) ->
      _.each TYPES, (type) ->
        type.active = type.name is name
        yes

    getMinPrices : ->
      prices = @generatePrices(8, 50, 0)
      prices.unshift(name : 'Any prices', value : '')
      prices

    getMaxPrices : ->
      prices = [{ name : '$90k', value : 90000 }, { name : '$180k', value : 180000 }]
      prices = _.concat prices, @generatePrices(5, 50, 250)
      prices.unshift(name : 'Any prices', value : '')
      prices

    generatePrices : (count, step = 1, padding = 1) ->
      _.map new Array(count), (item, index) ->
        name : "$#{index * step + padding}k"
        value : (index * step + padding) * 1000

    getBeds : ->
      _.map BEDS, (bed) -> { name : bed }

    getBaths : ->
      _.map BATHS, (bath) -> { name : bath }

    getHouseSizes : ->
      sizes = [{ name : 'Any', value : 0 }]
      sizes = _.concat sizes, @generateSizes(8, 200, 600)
      sizes = _.concat sizes, @generateSizes(4, 250, 2250)
      sizes.push(name : '3500+ sq ft', value : 3500)
      sizes = _.concat sizes, @generateSizes(7, 1000, 4000)

    generateSizes : (count, step = 1, padding = 1) ->
      _.map new Array(count), (item, index) ->
        name : "#{index * step + padding}+ sq ft"
        value : index * step + padding

    getLotSizes : ->
      LOT_SIZES

    getPropertyTypes : ->
      _.map PROPERTY_TYPES, (type) -> { name : type }

    getYears : ->
      startYear = (new Date()).getFullYear() - MAX_HOME_AGE
      years = _.map new Array(MAX_HOME_AGE), (item, index) ->
        name : startYear + index + 1
      _.orderBy years, ['name'], ['desc']

    type : ->
      _.find TYPES, (type) -> type.active is yes

    getSelectors : ->
      @selectors

]
