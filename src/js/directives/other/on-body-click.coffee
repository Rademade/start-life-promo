app.directive 'onBodyClick', () ->
  restrict : 'A'
  scope :
    condition : '='
    onBodyClickCb : '&'
  link : ($scope, $el, attrs) ->
    element = $el[0]

    onBodyClick = (e) ->
      unless isElementClicked(e.target)
        $scope.$apply $scope.onBodyClickCb

    isElementClicked = (target) ->
      return no unless $scope.condition
      return yes if target is element

      parent = target
      while parent = parent.parentElement
        return yes if parent is element
      no

    document.addEventListener 'click', onBodyClick

    $scope.$on '$destroy', () ->
      document.removeEventListener 'click', onBodyClick
