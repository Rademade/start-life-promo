app.directive 'customSelect', ->
  restrict : 'A'
  controller : 'customSelectController'
  controllerAs : 'customSelectCtrl'
  templateUrl : 'select/custom/template'
  scope :
    placeholder : '@'
    selector : '='
    onSelectedCb : '&'
    errorMessage : '='
    inputPlaceholder : '='
    autoClear : '='
