app.directive 'simpleSelect', ->
  restrict : 'A'
  controller : 'simpleSelectController'
  controllerAs : 'simpleSelectCtrl'
  templateUrl : 'select/simple/template'
  scope :
    placeholder : '@'
    placeholderDynamic : '@'
    selector : '<'
    hideValue : '='
    onSelectedCb : '&'
    errorMessage : '='
