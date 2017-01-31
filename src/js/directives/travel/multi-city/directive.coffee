app.directive 'multiCity', ->
  restrict : 'A'
  controller : 'multiCityController'
  controllerAs : 'multiCityCtrl'
  templateUrl : 'travel/multi-city/template'
  scope :
    syncService : '='
