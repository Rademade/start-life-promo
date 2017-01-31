app.controller 'customSelectController', [ '$timeout', '$scope', '$filter', ($timeout, $scope, $filter) ->
  ENTER_CODE = 13

  @placeholder = $scope.placeholder || ''
  @inputPlaceholder = $scope.inputPlaceholder || ''
  @selector = $scope.selector
  @autoClear = $scope.autoClear || no
  @query = ''

  @select = (selected) ->
    @selector.setSelected(selected)
    @selector.close()
    @query = if $scope.autoClear then '' else selected.name
    $scope.onSelectedCb()

  @onFocus = () ->
    @selector.open()

  @onChange = () ->
    temporarilyTurnedOff = true
    # @selector.setSelected(name : @query, value : @query)

  @getInputPlaceholder = () ->
    if @selector.isOpen then @inputPlaceholder else @placeholder

  @getValues = () ->
    values = @selector.values || []
    # $filter('filter')(values, @query)

  window.addEventListener 'keyup', (event) =>
    $timeout(() => @selector.close()) if event.keyCode is ENTER_CODE && @selector.isOpen

  return

]
