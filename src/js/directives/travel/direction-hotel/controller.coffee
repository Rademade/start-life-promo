app.controller 'directionHotelController', [
  '$scope', 'autocomplete',
  ($scope, autocomplete) ->

    @options = { types : '(cities)', watchEnter : false }

    @isEntered = (string) ->
      _.includes(string, ',')

    @updateCity = ->
      $scope.onSelectedCb({ data : $scope.autocomplete }) if @isEntered($scope.autocomplete)

    return

]
