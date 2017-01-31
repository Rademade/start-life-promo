app.controller 'locationController', [
  '$scope', 'autocomplete', '$timeout', '$element',
  ($scope, autocomplete, $timeout, $element) ->

    DEFAULT_PROVIDER = 'realtor'

    @placeholder = $scope.placeholder
    @service = $scope.service
    @data = []

    @updateAutocomplete = ->
      query = @service.getSelected()
      if query
        @data = []
        autocomplete.get($scope.provider || DEFAULT_PROVIDER, query).then (data) =>
          @data = data

    @enter = (e) ->
      @service.setSelected(e.srcElement.value)

      if e.srcElement.value
        unless window.isRequestPending()
          @updateAutocomplete()

    @onSelected = (result) =>
      if result?.originalObject
        @service.setSelected(result.originalObject)
      else if result?.city
        @service.setSelected(result)

    @updateFocus = () ->
      if $scope.focus
        e = $element[0].querySelector('input')
        setTimeout () ->
          e.focus()
        , 0

    return

]
