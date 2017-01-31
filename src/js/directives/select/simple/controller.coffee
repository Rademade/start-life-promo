app.controller 'simpleSelectController', [ '$scope', ($scope) ->

  @placeholder = $scope.placeholder || ''
  @isPlaceholderDynamic = $scope.placeholderDynamic || no
  @selector = $scope.selector
  @hideValue = $scope.hideValue || no
  @title = @placeholder

  @select = (selected) ->
    @selector.setSelected(selected)
    @selector.close()
    @placeholder = ''
    $scope.onSelectedCb()

  @getPlaceholderLabel = () ->
    if @isPlaceholderDynamic && @selector.selected?.name then '' else @placeholder

  @getPlaceholderValue = () ->
    if @selector.selected?
      if @title.match(/Exact dates/)
        @selector.selected?.name
      else
        if @selector.selected?.name.match(/Any/) then @title else @title+": "+@selector.selected?.name
    else
      ''

  return
]

