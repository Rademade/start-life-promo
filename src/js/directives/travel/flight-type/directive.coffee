app.directive 'flightType', ->
  restrict : 'A'
  controller : 'flightTypeController'
  controllerAs : 'flightTypeCtrl'
  templateUrl : 'travel/flight-type/template'
  scope :
    service : '='
    showClasses : '@'
    onToggleCb : '&'
    sync : '='
