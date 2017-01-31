app.controller 'hotelTypeController', [ '$scope', ($scope) ->

  @service = $scope.service

  @toggle = ->
    @service.toggle()
    $scope.onToggleCb(service : @service)

  @getSelectTitle = ->
    params = @service.getHotelParams()

    roomsCount = _.find(params, (item) -> item.name is 'Rooms').count
    guestsCount = _.find(params, (item) -> item.name is 'Guests').count

    rooms  = if roomsCount > 1 then "Rooms #{roomsCount}" else "Room 1"
    guests = if guestsCount > 1 then "Guests #{guestsCount}" else "Guest 1"
    "#{rooms}, #{guests}"

  return

]
