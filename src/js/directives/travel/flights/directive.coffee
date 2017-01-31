app.directive 'flights', ->
  restrict : 'A'
  controller : 'flightsController'
  controllerAs : 'flightsCtrl'
  templateUrl : 'travel/flights/template'
  scope :
    syncService : '='
    travelFactory : '='
