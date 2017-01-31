app.controller 'directionController', [
  '$scope', '$timeout', '$element', '$http', 'Airport',
  ($scope, $timeout, $element, $http, Airport) ->
    ARROW_KEYCODE_UP = 38
    ARROW_KEYCODE_DOWN = 40
    ENTER_CODE = 13

    @placeholder = $scope.placeholder
    @service = $scope.service
    $scope.firstSelection = yes
    @idArray = []

    @selected = ->
      e = $element[0].querySelector('input')
      if e.value.length > 0 && $scope.focus && $scope.selectFinished && $scope.cursorOnInput && $scope.firstSelection
        e.select()
        $scope.firstSelection = no

    @getHighlightedText = (text, highlightedPart) ->
      highlightedPart = highlightedPart[0].toUpperCase() + highlightedPart[1..-1].toLowerCase()
      '<span class="highlight">' + highlightedPart + '</span>' + text[highlightedPart.length..-1]

    @mouseover = ->
      $scope.cursorOnInput = yes

    @keyPressed = (event) ->
      index = _.findIndex @idArray, { 'active' : yes }
      @arrowUpPressed(index) if event.keyCode is ARROW_KEYCODE_UP
      @arrowDownPressed(index) if event.keyCode is ARROW_KEYCODE_DOWN
      @selectAirport(index) if event.keyCode is ENTER_CODE

    @arrowUpPressed = (index) =>
      last = _.last(@idArray)
      if index is -1
        @setAirportActive(last)
      else
        @idArray[index].active = no
        if index > 0
          @setAirportActive(@idArray[index-1])
        else
          @setAirportActive(last)

    @setAirportActive = (airport) ->
      @currentId = airport.id
      airport.active = yes

    @arrowDownPressed = (index) ->
      first = _.first(@idArray)
      if index is -1
        @setAirportActive(first)
      else
        @idArray[index].active = no
        if index isnt @idArray.length - 1
          @setAirportActive(@idArray[index+1])
        else
          @setAirportActive(first)

    @selectAirport = (index) ->
      return if index is -1
      text = @idArray[index].text
      i = _.findIndex $scope.data[0..9], { 'text' : text }
      @onSelected($scope.data[i]) if i > -1

    @clearId = () ->
      @currentId = null

    @setFocus = ->
      $scope.focus = yes

    @blurFocus = ->
      $scope.focus = no
      $scope.cursorOnInput = no
      $scope.firstSelection = yes

    @clearData = ->
      $scope.data = null

    @inputChangeHandler = (query) ->
      if query.length > 0
        Airport.getAutocomplete(query).then((data) ->
          $scope.data = data
          $scope.highlightedPart = query
        )
      else
        $scope.data = null

    @onSelected = (result) ->
      if _.isObject(result)
        @setFlyghtParams(result)
        e = $element[0].querySelector('input')
        e.value = result.text
        @clearData()
        $scope.selectFinished = yes
        $scope.focus = no
        $scope.onSelectedCb()

    @setFlyghtParams = (params) ->
      @service.setAirportCode(params.airport_code)
      @service.setDirection(params.text)
      @service.setAirportId(params.id.$oid)

    $scope.$watch 'data', =>
      if $scope.data
        $timeout =>
          airports = $element[0].querySelectorAll('.angucomplete-title')
          longestName = _.maxBy(airports, 'clientWidth').clientWidth if airports.length > 0
          el = $element[0].querySelector('.angucomplete-dropdown')
          if longestName > 250
            el.style.width = String(longestName) + "px"
          else
            el.style.width = "250px"
          @setIdArray($scope.data[0..9])
        , 0

    @setIdArray = (airports) =>
      @idArray = []
      _.each airports, (airport) =>
        data = { id : airport.id.$oid, active : no, text : airport.text }
        @idArray.push data
        yes

    return

]
