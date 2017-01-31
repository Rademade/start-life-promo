app.controller 'siteSelectController', [
  '$scope', '$filter',
  ($scope, $filter) ->

    ENTER_CODE = 13

    @selector = $scope.selector
    @query = ''

    @select = (selected) ->
      @selector.setSelected(selected)
      @selector.close()
      @query = ''
      $scope.onSelectedCb()

    @getValues = () ->
      values = @selector.values || []
      values = $filter('orderBy')(values, 'name')
      regex = new RegExp('^' + @query, 'i')
      values = $filter('regex')(values, 'name', regex)

    @onChange = () ->
      $scope.onChangeCb({ sites : @getValues() })

    window.addEventListener 'keyup', (event) =>
      @query = '' if event.keyCode is ENTER_CODE

    return

]
