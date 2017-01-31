app.directive 'oneWay', ->
  restrict : 'A'
  controller : 'oneWayController'
  controllerAs : 'oneWayCtrl'
  templateUrl : 'travel/one-way/template'
  scope :
    syncService : '='
