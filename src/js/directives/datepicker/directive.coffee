app.directive 'datepicker', ->
  restrict : 'A'
  controller : 'datepickerController'
  controllerAs : 'datepickerCtrl'
  templateUrl : 'datepicker/template'
  scope :
    service : '='
    onSelectCb : '&'
    onToggleCb : '&'
    placeholder : '@'
    errorMessage : '='
    focus : '='
