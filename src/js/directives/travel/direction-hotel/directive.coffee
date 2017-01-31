app.directive 'directionHotel', ->
  restrict : 'A'
  controller : 'directionHotelController'
  controllerAs : 'directionHotelCtrl'
  templateUrl : 'travel/direction-hotel/template'
  scope :
    onSelectedCb : '&'
    errorMessage : '='
