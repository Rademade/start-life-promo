app.directive 'roundTrip', ->
  restrict : 'A'
  controller : 'roundTripController'
  controllerAs : 'roundTripCtrl'
  templateUrl : 'travel/round-trip/template'
  scope :
    syncService : '='
