app.controller 'flightTypeController', [ '$scope', ($scope) ->

  CSS_CLASS_CURRENT = 'is-current'

  @showClasses = $scope.showClasses || no
  @service = $scope.service

  @toggle = ->
    $scope.service.toggle()
    $scope.onToggleCb(flightType :  $scope.service)

  @getSelectTitle = ->
    count = @service.getTravelersCount()
    flightClass = @service.getSelectedFlightClass()
    result = if count then "Travelers #{count}" else 'Travelers'
    if count && flightClass && @showClasses
      result += ", #{flightClass}"
    result

  @getClass = () ->
    css = []
    if @service.getIsOpen()
      css.push CSS_CLASS_CURRENT
    css.join(' ')

  @setFlightClass = (name) ->
    @service.setSelectedFlightClass(name)
    @save()

  @incrementCount = (type) ->
    @service.incrementCount(type)
    @save()

  @decrementCount = (type) ->
    @service.decrementCount(type)
    @save()

  @init = () ->
    data = $scope.sync.getTravelersData()
    if data
      @service.setSelectedFlightClass(data.class)
      @service.setTravelerTypes(data.types)

  @save = () ->
    data =
      types : _.map @service.getFlightTypes(), (type) ->
        name : type.name
        count : type.count
      class : @service.getSelectedFlightClass()
    $scope.sync.setTravelersData(data)

  @init()

  return

]
