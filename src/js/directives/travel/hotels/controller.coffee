app.controller 'hotelsController', [
  'linkOpener', '$scope', 'HotelFactory', 'linkGenerator', 'inputFocuser', '$element',
  (linkOpener, $scope, HotelFactory, linkGenerator, inputFocuser, $element) ->
    E = $element[0]

    CSS_CLASS_CURRENT = 'is-current'
    CSS_CLASS_ERROR = 'is-error'
    CSS_CLASS_DISABLED = 'is-disabled'

    @sync = $scope.syncService
    @focusFrom = false

    @init = () ->
      count = 0
      data = @sync.getTravelersData()
      if data
        count = _.sum _.map(data.types, (type) -> type.count)
      @factory = new HotelFactory(@sync.getDirection(), count)
      setTimeout ->
        inputFocuser.focus({ element : E, index : 0 })
      , 0

    @init()

    @isFormSubmitted = no

    @openSite = (site) ->
      linkOpener.open(site)

    @open = (site) ->
      @isFormSubmitted = yes
      params = _.merge @factory.getParams(), site : site

      if params.date_from && params.date_to && params.city
        link = linkGenerator.getHotelLink(params)
        linkOpener.open(link)

    @isCityError = (selector) =>
      !selector.getDirection() && @isFormSubmitted

    @isDateError = (date) ->
      !date.getDate() && @isFormSubmitted

    @setCity = (data = null) ->
      @factory.city.setDirection(data) if data
      city = @factory.city.getCity()
      @sync.setCity(city) if city
      @focusFrom = true if city

    @isDateError = (date) ->
      !date.getDate() && @isFormSubmitted

    @getDatepickerClass = (datepicker, isDisabled = no) ->
      css = []
      if isDisabled
        css.push CSS_CLASS_DISABLED
      else
        if @factory.isOpen(datepicker)
          css.push CSS_CLASS_CURRENT
        else if @isDateError(datepicker)
          css.push CSS_CLASS_ERROR
      css.join(' ')

    @getDateToDatepickerCss = () ->
      @getDatepickerClass(@factory.dateTo) # if will need to disable "Chek out": @factory.dateFrom.isNotSelectedDate()

    return

]
