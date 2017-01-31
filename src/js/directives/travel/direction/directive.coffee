app.directive 'direction', ->
  restrict : 'A'
  controller : 'directionController'
  controllerAs : 'directionCtrl'
  templateUrl : 'travel/direction/template'
  scope :
    placeholder : '@'
    service : '='
    onSelectedCb : '&'
    errorMessage : '='
    focus : '=?'
    data : '=?'
    cursorOnInput : '=?'
    selectFinished : '=?'
    firstSelection : '=?'
    highlightedPart : '=?'