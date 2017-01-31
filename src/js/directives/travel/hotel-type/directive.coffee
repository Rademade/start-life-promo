app.directive 'hotelType', ->
  restrict : 'A'
  controller : 'hotelTypeController'
  controllerAs : 'hotelTypeCtrl'
  templateUrl : 'travel/hotel-type/template'
  scope :
    service : '='
    onToggleCb : '&'
